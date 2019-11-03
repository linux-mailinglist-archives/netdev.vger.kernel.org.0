Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B42C5ED19A
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 04:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfKCDxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 23:53:54 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35035 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbfKCDxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 23:53:54 -0400
Received: by mail-qt1-f196.google.com with SMTP id r22so8639118qtt.2;
        Sat, 02 Nov 2019 20:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=wOg1PtFWo6IuY/J6e5WFjVi85apyAhEHv0iLtW+bwFo=;
        b=CFqU6jq+P0UI+cv5IHF/a/9cZZ3yMEv3k1uupJ9pV9YxxCPEcXfx17VZrG9M3Ug+HT
         QWTj+U2Q0FWEs9wNROaslzazsmJE5AylnnO4gsCEi6bXcUygsgU+PLygddN+QLvDWUsm
         GeW/9Kslm8141admwFcmpXjbAZABkQScgKqjeBxSsxE8166TAmFvBC6bBZtp4H01TSyl
         RlPAh1hcRReAsuXsW1MsicZWe+OQut5KuJVxnNujmuZn6qSb3VSiG9kAoccy/5ExVReo
         uZRXmlTLZlRV0xBuvG/TeudJg/8wUIGOzmbC5PJ+018cYrIBE32fvi1LBy65jLEnz6/T
         Pclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=wOg1PtFWo6IuY/J6e5WFjVi85apyAhEHv0iLtW+bwFo=;
        b=sr+t8WADk2fU65wYolaDyETkjLw1ckG5bTqfbwHBY8HNIvQo9WIRskEEakS2hxlB+Q
         304HnZqtFbFY192I8OOMb541tsEi9DAQ+SzXM25m0gK7nBjjBDXpOT7pIAORkWO7TbkY
         ZZsa2Vrp3ILoxeNWBureezHXWeQ/djxZ3CYKYrlH/ccc02VcJGvEaF728iGOcrEgUVtk
         w56wBBMf9NtyvSg7jVm2NZe09xlVVm+84/r+UoR/xnVoa/IpgLaNxB0P0L70RmLanKui
         l/p58WBl4f6SBUNqkxkHqGuEChoK3VJITG9LD8oIWOe7S9yLcp465O5WoLIyeNtQhsQ8
         9/SA==
X-Gm-Message-State: APjAAAWEQl5MJ6A7D+igSlI/5LxMN+yK4lMVhAS5Y9PWJNRdCTozeAdL
        mDnrc8c6CcClImp5YlWOqve+Rj+K
X-Google-Smtp-Source: APXvYqz4tLR5aUuIH0GTzsUXFr7TSUJawGe446heeTCl8EBtsE0BtW4rvrfz222pTXSfBGnl1WRKbg==
X-Received: by 2002:ac8:28e3:: with SMTP id j32mr6623627qtj.212.1572753233114;
        Sat, 02 Nov 2019 20:53:53 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id e18sm1811995qto.32.2019.11.02.20.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Nov 2019 20:53:52 -0700 (PDT)
Date:   Sat, 2 Nov 2019 23:53:50 -0400
Message-ID: <20191102235350.GB417753@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        hkallweit1@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: Fix use after free in
 dsa_switch_remove()
In-Reply-To: <20191103031326.26873-1-f.fainelli@gmail.com>
References: <20191103031326.26873-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  2 Nov 2019 20:13:26 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> The order in which the ports are deleted from the list and freed and the
> call to dsa_tree_remove_switch() is done is reversed, which leads to an

s/dsa_tree_remove_switch/dsa_switch_remove/

> use after free condition. Reverse the two: first tear down the ports and
> switch from the fabric, then free the ports associated with that switch
> fabric.
> 
> Fixes: 05f294a85235 ("net: dsa: allocate ports on touch")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks for reporting and fixing this!

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>

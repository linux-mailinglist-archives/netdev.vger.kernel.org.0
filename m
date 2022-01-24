Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE91498442
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243418AbiAXQIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:08:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243398AbiAXQIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:08:24 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E326C06173B;
        Mon, 24 Jan 2022 08:08:24 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id a18so57327187edj.7;
        Mon, 24 Jan 2022 08:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n5KUYw0ELAiNZLFMVEF7Z0jsxRInQV4yLzts3fn+HnA=;
        b=a2isgg4Xoe01c3TCBzD/QMePsOMRQ4MpjSnWRlDw2IemF6TLPzLZF4hsez/Xpfm2xu
         R22AfBsJD0qDDbtZ0vdXClrp/LvF3yNBymCjfXSQ+1MlOmP4kqBzYD0yvSXuUEd5zBSW
         QZ+PcaFhVAhf+oBDN90RtuOUR3k51B8bOZKXoYsvb3mtMnqpjFwCgg33EFlOruPQtwe2
         2vNHVP+xGM//2lHu/vhHNcFBTYCDGQZxtVwz/OhPvmZhd+snaJe6fq+/7FIMnKP4NtTa
         hJYtJpRlrWQss/vHktOH2BSn6jUdRaMZfuySKoYnl3b2x/LXzLCGfAAFIgfHpwtJS77x
         lXwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n5KUYw0ELAiNZLFMVEF7Z0jsxRInQV4yLzts3fn+HnA=;
        b=7v3XJMWtxa8H4W4RbD1rKT7ntFDMYoMCK4udW9FFzwzwZlI5VjzjEXXYjgiQtozb9C
         Wj2AkZl4+4dBtFHvM82Kt8fQ4lABm667PEsROpbOMhtLmLNX58a+v18cvMisaMKRn5zi
         Pm9dQjKi3GFZTDEZ0K4ikX8FSPSHrdC4IptEkHStsP0Y1o/kK1V8B0W+Piliat1sAVom
         Hyp9ZOJGNT0S5muEMZj7m6PWfwT/+lMVIAleijkxxJFFZ/H8rhS/6x1pIUpmt6fxPDS+
         oUmX+0DJ0Wb5buVP03mD+DUEshVR/Dm5qpiBDVfcJJsWGHCF1uEi1yzu8YwmVsdV52wZ
         RLNw==
X-Gm-Message-State: AOAM532zumJ99AciEsSLsNMrxn6dCqXHDTS96JIisn/dmfcUdj46S3Qn
        O9YqFdPtAknyZHGVMTL12wI=
X-Google-Smtp-Source: ABdhPJzT9SLSu8rvEJ9OZQq4MwMhma4EgzWXPCUsJ4tFWLSqYimpKj7BmuuoGhS4ML3VcVtyspSOiA==
X-Received: by 2002:a05:6402:490:: with SMTP id k16mr16874845edv.99.1643040502689;
        Mon, 24 Jan 2022 08:08:22 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id y2sm5030957ejh.80.2022.01.24.08.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 08:08:22 -0800 (PST)
Date:   Mon, 24 Jan 2022 18:08:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 08/16] net: dsa: tag_qca: add support for handling
 mgmt and MIB Ethernet packet
Message-ID: <20220124160819.smi2nbvgg5cwdadr@skbuf>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-9-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123013337.20945-9-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 02:33:29AM +0100, Ansuel Smith wrote:
> Add connect/disconnect helper to assign private struct to the dsa switch.
> Add support for Ethernet mgm and MIB if the dsa driver provide an handler
> to correctly parse and elaborate the data.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

This seems ok to me, would like some feedback from Andrew, Vivien and
Florian too.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

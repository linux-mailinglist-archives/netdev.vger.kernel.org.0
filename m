Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3342D1F2C
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbfJJEGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:06:42 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36062 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbfJJEGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:06:41 -0400
Received: by mail-pf1-f194.google.com with SMTP id y22so3016520pfr.3
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=GoaiABsNcjktrXV89afoqH1ZyzShzXS7gXEVVeoSXxg=;
        b=WTe2NRzi8QSW5PG68Bq2CMnLyCFsAw7l/lejAmBsp9p6GuW0JHXnwc/wFPlWd0uQH0
         ZYiDmklYn/djp4YJUeBAwCjsD0FXEXLXW5sS7H9CJd2gwN2CYirJoYwfjywk5+hcG1Yw
         QqvdZS9O5VmrI7teo25iaIh91EGL8dFaaY15un8hP+2vjzyv+jsA4yz9XnbrH4DY6v6V
         J1oEibCR9Hibv1zJgXx0Olo8HK3hBLwxeStphAm5nD+RE/NPZ281sXidX7AzRJ+PSXbO
         XJ1/rMlUzXJWo6gk8BJK6gNWjS+VrC/9PYj97p+LOac26cSfhUPRCqdp5zLiueErbzPM
         J68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=GoaiABsNcjktrXV89afoqH1ZyzShzXS7gXEVVeoSXxg=;
        b=J+O0HSJTWMy3gYOm6IJ9CQQq9kdeYSo9xwu0MTEYOUu5W+6VXDE7DAHy8yZxuk7hx7
         FAlyyW4+BiEnQHnhnD//LbtGy/TQMPDJOOu8cb5PoRfd0qNrsMcaJkAXigJY+y8yAI/a
         LaBlHHT7/WcnpzZ46oQz/1c74KyjmXn66lMEg1cx2Bo9OwGrU2OmJxKRSSAUVvIxyAD2
         WVpjPL7YiO8ZXt1u+YSX1K9rwF8v0WOjKI1D10dX3AbW5v/gDvuy93x7dPLyK//hMpce
         QRDun5rZtLLzgNFgstmwx1XdDjSD9Lr6nA72DI7+PCRJXFeMDLKhnz2/0WrTcHCzRb0p
         50cw==
X-Gm-Message-State: APjAAAUheMU3K0mCm0F54ToMp7tBiVzDtbVggu4+Pj/E9r4crpd4HhrV
        19apZwII2aXTHG4Db2yd/0GqKw==
X-Google-Smtp-Source: APXvYqyWs6UzN3ruhhPfthNrVv9Pn7KnnelkNKWg4YSmyJtJejJFCwiH8SsHxYUlN2HH33ePvqKdig==
X-Received: by 2002:a17:90a:654b:: with SMTP id f11mr8553946pjs.49.1570680401166;
        Wed, 09 Oct 2019 21:06:41 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id i126sm4090224pfc.29.2019.10.09.21.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 21:06:40 -0700 (PDT)
Date:   Wed, 9 Oct 2019 21:06:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>, gnault@redhat.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] netns: fix NLM_F_ECHO mechanism for RTM_NEWNSID
Message-ID: <20191009210628.701ed0b8@cakuba.netronome.com>
In-Reply-To: <20191009091910.4199-1-nicolas.dichtel@6wind.com>
References: <20191008231047.GB4779@linux.home>
        <20191009091910.4199-1-nicolas.dichtel@6wind.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 11:19:10 +0200, Nicolas Dichtel wrote:
> The flag NLM_F_ECHO aims to reply to the user the message notified to all
> listeners.
> It was not the case with the command RTM_NEWNSID, let's fix this.
> 
> Fixes: 0c7aecd4bde4 ("netns: add rtnl cmd to add and get peer netns ids")
> Reported-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied, thanks! 

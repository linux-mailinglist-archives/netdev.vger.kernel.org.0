Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E45310816B
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 03:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKXCIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 21:08:39 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45133 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKXCIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 21:08:39 -0500
Received: by mail-pf1-f196.google.com with SMTP id z4so5511027pfn.12
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 18:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=6jtiTmu1ZcI55UEOm35N8Ys5F5gxeV6qzoQfOxrOHJM=;
        b=F4GjW3rnw43Ox3qmA1dhtt2cqTtCtqrBI4P2GqfcJNRR+U7d9Ab/jUKTfN1M73riQW
         z4ZOSNVPvGcTtUUngIJ6aBUymtxXv9NfCuLgaONVirPUYOeYKqHhUyvuQLdn9C6ilUbp
         /HrikqkcMkmSANmQd3PY+muSfZ6kz705hyf7n6LG6C3yCywg0ZTmkD3w6RDeCWJyMDcz
         CYITHwvFsONkmeXdpKVzJS4ADHJ+4n/r7iwpgiAaGkZxrXl+zbC/82iBRjRGRA5GzgoC
         Xgv2mB7B95oRKyPL22aoKNduWlkHjioGAfzrKpUeaZ0C7Yk5oTXgHGaPKElPtlUteKCc
         7oyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6jtiTmu1ZcI55UEOm35N8Ys5F5gxeV6qzoQfOxrOHJM=;
        b=BB1BU1w0S3x8mCfeLKtj3AwLx+YrOAtDpMGEK1KxQjOPVvGVnk2H5udaQVqCAlrBKx
         8H8B7JesnLfeuKFqA3YemrMeTmYvIyS19dTt+xkhk5ae0F146ZAYOPHj1iD/4USedmxy
         IAZwp78nx5Pmf/MeS8VKXsCXNwXN3q9+9nwnTyzXTKNbN29fvosq+IBx6uUld0VttpdG
         CoLyW/QFb0q07h71cClpyFJxHZaN8MSamR3mYrAh7pdSvnE6xDembpV6LjhmR4uHsJ4+
         PLOYHOIM9LmQibNRvf0vCFK8t759lFIZjG3STjuGUBkCkzsneVp9ROZ9A4HqkNXhvtLw
         2x/g==
X-Gm-Message-State: APjAAAWpXK4kAeCirpMdqblCjj6t5ickTvlrtFBiSf93c0PYVmH0fIQR
        r9UrC77zopcdwTDsaD4A0OQ7I0ZNAxA=
X-Google-Smtp-Source: APXvYqyndJoc0YO7snCrD8uro+pH6ZiLwhAhO1h0VxvJywjpIo/I6Y1jHd4+YJiIoF9JdPbnhlof8g==
X-Received: by 2002:a63:ec50:: with SMTP id r16mr24711910pgj.284.1574561318821;
        Sat, 23 Nov 2019 18:08:38 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id q66sm2939481pfb.150.2019.11.23.18.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 18:08:38 -0800 (PST)
Date:   Sat, 23 Nov 2019 18:08:34 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH next-net] net: gro: use vlan API instead of accessing
 directly
Message-ID: <20191123180823.6b2d3696@cakuba.netronome.com>
In-Reply-To: <1574426281-52829-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1574426281-52829-1-git-send-email-xiangxia.m.yue@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 20:38:01 +0800, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Use vlan common api to access the vlan_tag info.
> 
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Applied, thanks!

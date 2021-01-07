Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A506E2ECC83
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbhAGJPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:15:17 -0500
Received: from mail-03.mail-europe.com ([91.134.188.129]:55780 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbhAGJPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:15:15 -0500
Date:   Thu, 07 Jan 2021 09:13:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610010826; bh=hvwIoelUi1wx+za4I6FAa+/pn9VbnZdTGjdvOxoB1zU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Y3+xzT7cHW/sNusbEjY8I4TqKzQszsQ7W6lvZv6YnOxGsezOcMfGYhuhpdn3kejN+
         EzvCGyjX8hJEzXfyggRFglqAnLo8WjnnkOB0MlOl1TVghUW/66ovOGBFr+L9a7vQUA
         xCwEwngvOEhR++W5p+IVwC/ludLOiIOn+GVFyyKoUU+x8J5nPXYbnjymhZL8GFAEoh
         bGe9VlzdM4Wqcl/45Z+xyRzTE7r4iG+2/EJ3zF421XDEDxwx3aJ0M1DQiL2g9V7hO9
         KnSqX5cWxOZdvL9yUcfDRqU03dCJDM0t3uvUKA/4wZmk78i/i02LgUK9fx+9Ke5/u9
         c/ZAqI6rZ3pmg==
To:     Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next] net: sysctl: cleanup net_sysctl_init()
Message-ID: <20210107091318.2184-1-alobakin@pm.me>
In-Reply-To: <20210106163056.79d75ffa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210106204014.34730-1-alobakin@pm.me> <20210106163056.79d75ffa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 6 Jan 2021 16:30:56 -0800

> On Wed, 06 Jan 2021 20:40:28 +0000 Alexander Lobakin wrote:
>> 'net_header' is not used outside of this function, so can be moved
>> from BSS onto the stack.
>> Declarations of one-element arrays are discouraged, and there's no
>> need to store 'empty' in BSS. Simply allocate it from heap at init.
>
> Are you sure? It's passed as an argument to register_sysctl()
> so it may well need to be valid for the lifetime of net_header.

I just moved it from BSS to the heap and allocate it using kzalloc(),
it's still valid through the lifetime of the kernel.

Al


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EA447FBAC
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 10:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhL0J4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 04:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhL0J4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 04:56:50 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C181C06173E;
        Mon, 27 Dec 2021 01:56:49 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id x21so33733854lfa.5;
        Mon, 27 Dec 2021 01:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=9fWHcMAbQHI5xWkUx6lceWEkgpVdlT25SBzMHtgoJuQ=;
        b=PcjF9f0adWqt2K0TqtF9/SOC0EGi3xlg2BuYA+TsuGheXaGDVE77l81O6CnIvuAWki
         nhhy/1bLfJiLHfCOGQgqjVC6uRmTum9LV2yE/tEVauZsrAiYybP4Bh4SpG2KsoGeNJ1L
         8TePxw7UCLXiwX+T0QbRO9C71SGen934CNPJL7Sd2zLHziIORWRvReovpktfZJpeZuhd
         RWYVQmc+8R0nsINO3uFyAYHfemJBycFDE46rT1t6EJ/RwrJf31PFGWI7XDypx25Qfx1C
         xBFln0ju7DaVFQc63bclYmVbNM6E1ZxnIe+V3iejDwab4oRaXcOY84Y+8ZedKj4sltuT
         P13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=9fWHcMAbQHI5xWkUx6lceWEkgpVdlT25SBzMHtgoJuQ=;
        b=zX/3iiK6E/ZzFl7BuVdua9ckbLa9unBMuz4fKJNrupAEyuzAS8uV8LNr2pbOJ/+hFb
         bDbWEz6CgxNCFuzW985m/yS5vw5j4lVq1d97bld8+GDygcY+BO4QQPyAebEd/u2e+gai
         RTQ+1RZM6Wxuih95ejAJovAzZLOSgdzbSYigYeoIvN1zuPckjDFUqk954YlUdFjH0c5j
         oTkIaWl5gOgksCXWvEkvaN7xd4OmxtgSOOXK1MD2kTUCjipL9/bNsK0qjTKh2kYi1mHK
         bNkkKyBN1eESJkUcbgMjutOvtquEPSj5tWGZs3d7dsflDVOr4Gfxs5Zn3sHTjLWQGdew
         rIfQ==
X-Gm-Message-State: AOAM530mu4DZ6HHqIbTTQbLnRyqRZgNRD2UcaP3Qr/TiW0BdPdDctz5R
        DJyZgW4apVS7Qn5EZqhGj5YZBMSyBBs=
X-Google-Smtp-Source: ABdhPJwhawMF7oBUEgjR2M9jLXUxf5U42a9pnF10LwKNy02G77chpTMStVAFjvntoQ4p4Bb1/MEekQ==
X-Received: by 2002:a05:6512:308a:: with SMTP id z10mr15046128lfd.594.1640599007838;
        Mon, 27 Dec 2021 01:56:47 -0800 (PST)
Received: from [192.168.1.100] ([178.176.79.51])
        by smtp.gmail.com with ESMTPSA id g11sm1585418lfr.236.2021.12.27.01.56.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Dec 2021 01:56:47 -0800 (PST)
Message-ID: <36ee5c5c-a03c-c9f5-dd5c-9e3a04b0374a@gmail.com>
Date:   Mon, 27 Dec 2021 12:56:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] net: usb: pegasus: Do not drop long Ethernet frames
Content-Language: en-US
To:     Matthias-Christian Ott <ott@mirix.org>,
        Petko Manolov <petkan@nucleusys.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
References: <20211226132930.7220-1-ott@mirix.org>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
In-Reply-To: <20211226132930.7220-1-ott@mirix.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 26.12.2021 16:29, Matthias-Christian Ott wrote:

> The D-Link DSB-650TX (2001:4002) is unable to receive Ethernet frames
> that are longer than 1518 octets, for example, Ethernet frames that
> contain 802.1Q VLAN tags.
> 
> The frames are sent to the pegasus driver via USB but the driver
> discards them because they have the Long_pkt field set to 1 in the
> received status report. The function read_bulk_callback of the pegasus
> driver treats such received "packets" (in the terminology of the
> hardware) as errors but the field simply does just indicate that the
> Ethernet frame (MAC destination to FCS) is longer than 1518 octets.
> 
> It seems that in the 1990s there was a distinction between
> "giant" (> 1518) and "runt" (< 64) frames and the hardware includes
> flags to indicate this distinction. It seems that the purpose of the
> distinction "giant" frames was to not allow infinitely long frames due
> to transmission errors and to allow hardware to have an upper limit of
> the frame size. However, the hardware already has such limit with its
> 2048 octet receive buffer and, therefore, Long_pkt is merely a
> convention and should not be treated as a receive error.
> 
> Actually, the hardware is even able to receive Ethernet frames with 2048
> octets which exceeds the claimed limit frame size limit of the driver of
                                    ^^^^^            ^^^^^
    Too many limits. :-)

> 1536 octets (PEGASUS_MTU).
> 
> Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
[...]

MBR, Sergey

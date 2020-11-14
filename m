Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38292B2A4B
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 02:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgKNBI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 20:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgKNBI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 20:08:57 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90060C0613D1;
        Fri, 13 Nov 2020 17:08:57 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id y17so10758816ejh.11;
        Fri, 13 Nov 2020 17:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dTLxbP8TR+LwwP03s0i7XGYRX4tK/OgFUNuNFm6qbL4=;
        b=Z/4QHmzeySKvr630PVTbxh9bSUL6yJ1nTEt77sBH1ZGx5NFu5kXJUsnracYcHfdHq7
         CUezGSOidfz03PWEzdV5daXI+ALkK/i/wksXedjdOrENGD05Ojpz6ifrL+Fsn8SjzMfh
         NqHp0oUHYAI/+JMkQVN1PD+LmtYgBQvWsws8FOpOkMBDpUC46TBt/x/O6VFz4pV5A8Ah
         HsXbzyqQkZPWnAIOi7A95+zz2zG+jy1UDa9nXoqqFH43UnW64gp4/1BXb0EYUJ6G4jtV
         +/Yt+tSgYZ4yU164p1NTX+RnDI7wTf9oliGuKz5yEfBsGNh5JiLa2DMymIb403iIT2Mu
         7T1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dTLxbP8TR+LwwP03s0i7XGYRX4tK/OgFUNuNFm6qbL4=;
        b=JwIUgihQfZH6TtIaZmXZBBXntO6URZsdcG8e5uMNTPUp9SMpLpDWQvb+9DVSPcUhgJ
         o0/uOUVgOMGErjQbV26e35W9/wploUqJKik5zFTXaY9yg0xwvwJ62IilJgzpxkn34BOL
         4tVvHCy07i8A6DOoaC9ugFVVLRLpFBfp74oKov8tsAfq4t++qW6gLDCtUrqa7ESdCcdM
         PSPVtog7Uvhmqju2b4GQUh1ETu7QVrIjUODuUt1TtMfgsQeKqBIio+RCpsEb1GQaCeOD
         v6J29iC70lmkSXeBlvaVnLCRONDkH2fJyxKMHWBG7bDK6FLxx+POmKnJl0SkfmGuTJvP
         Ip9Q==
X-Gm-Message-State: AOAM530GnGPEaZIGBn0Lq5rQM2tBHSGolnCj02GBb+gE9tHioqGJU/cy
        lMrAhpyfFbDKGaVgjhJXgYc=
X-Google-Smtp-Source: ABdhPJzx1FHnodv6OryTuahBWZs7WInewLfYzXH7PLtn9slh7vbFXZhBoPP+AGGyeuuJzjnfg2LJCg==
X-Received: by 2002:a17:906:9719:: with SMTP id k25mr4630030ejx.226.1605316136146;
        Fri, 13 Nov 2020 17:08:56 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id k10sm5005129ejh.32.2020.11.13.17.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 17:08:55 -0800 (PST)
Date:   Sat, 14 Nov 2020 03:08:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: Re: [PATCH v2 08/10] ARM: dts: NSP: Add a SRAB compatible string for
 each board
Message-ID: <20201114010854.42lh4dyn4osw6hcz@skbuf>
References: <20201112045020.9766-1-f.fainelli@gmail.com>
 <20201112045020.9766-9-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112045020.9766-9-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 08:50:18PM -0800, Florian Fainelli wrote:
> Provide a valid compatible string for the Ethernet switch node based on
> the board including the switch. This allows us to have sane defaults and
> silences the following warnings:
> 
>  arch/arm/boot/dts/bcm958522er.dt.yaml:
>     ethernet-switch@36000: compatible: 'oneOf' conditional failed,
> one
>     must be fixed:
>             ['brcm,bcm5301x-srab'] is too short
>             'brcm,bcm5325' was expected
>             'brcm,bcm53115' was expected
>             'brcm,bcm53125' was expected
>             'brcm,bcm53128' was expected
>             'brcm,bcm5365' was expected
>             'brcm,bcm5395' was expected
>             'brcm,bcm5389' was expected
>             'brcm,bcm5397' was expected
>             'brcm,bcm5398' was expected
>             'brcm,bcm11360-srab' was expected
>             'brcm,bcm5301x-srab' is not one of ['brcm,bcm53010-srab',
>     'brcm,bcm53011-srab', 'brcm,bcm53012-srab', 'brcm,bcm53018-srab',
>     'brcm,bcm53019-srab']
>             'brcm,bcm5301x-srab' is not one of ['brcm,bcm11404-srab',
>     'brcm,bcm11407-srab', 'brcm,bcm11409-srab', 'brcm,bcm58310-srab',
>     'brcm,bcm58311-srab', 'brcm,bcm58313-srab']
>             'brcm,bcm5301x-srab' is not one of ['brcm,bcm58522-srab',
>     'brcm,bcm58523-srab', 'brcm,bcm58525-srab', 'brcm,bcm58622-srab',
>     'brcm,bcm58623-srab', 'brcm,bcm58625-srab', 'brcm,bcm88312-srab']
>             'brcm,bcm5301x-srab' is not one of ['brcm,bcm3384-switch',
>     'brcm,bcm6328-switch', 'brcm,bcm6368-switch']
>             From schema:
>     Documentation/devicetree/bindings/net/dsa/b53.yaml
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

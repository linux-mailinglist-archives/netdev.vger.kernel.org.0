Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0300333D00E
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbhCPImz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbhCPIml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:42:41 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBECC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 01:42:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ci14so70575592ejc.7
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 01:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D81ZG1imTGMYNDCoHnjjo5myhiJwEX2QL5C0JYniZS8=;
        b=bIBE1LJOZP0HvlRWorsws07f9PlPH8qE7RNhCjGeF1JJWaIbK298XfimbxPtsj53oy
         8NEFUDAhDYo/buwlubxiIvlvkbt0MzgfyYwUeE7oM2qa9vvO6nP7utUCLPCfU6SrVupW
         PcvSON/q5BKJ/FawQbg6/d6Ayh0XNs1n0NJpeAyl5vNl6GgG4PScVlUXoREIwa0QEJJ1
         2TuNthQajc6E3vMBlB46FMyMpCswR583czHeprLcSVUpKQamL/8vIJCNX/B9LA2Nr2If
         NmWMFMgW+m8QmlVY94qWP0v7v+rnpybmEpUxsBDsBaDrPi1hBpRCNWAjZ/kPTSU6XzVv
         +WbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D81ZG1imTGMYNDCoHnjjo5myhiJwEX2QL5C0JYniZS8=;
        b=ngU+KmGst1cZMO8tauxbcFTgifqYQofXIzh+bMD/4JLSFPa/1UoKTvVTB9exnnVjB6
         mYWuxzoM5pG/zdf3kE1Zo7lYksY6/Ut9s986c/zBDGPwQc7tKDT4RZ8gpfLQRKxP5hF6
         xu4Gqu4w/Olf+OnzGAQ3fE5/dDvR+qPEKGBR9/bo5DtHgSVHjU16K8SJ/oU31VPd0NUl
         Y8M2lqzXzZXW6VrGhjrzHDcUar6LBpg8J4SkaxqOBePmP4az342tAYXMz021yDPbiytF
         x8jz3F+SY9hPnIFHqfmXaWgcXeCPlUBKVGnXsvibn4rXtgr6x3VpecuRxtb2+mxJ6vDC
         q0ng==
X-Gm-Message-State: AOAM531AhhoSIQPNdeaIDpJXEDT4WQcl9deBDH8rdAogLrLQrL3+MwfV
        Gy/atTOLlGMeMb6A5ZT4f4k=
X-Google-Smtp-Source: ABdhPJxb2KW2pqu2zN+3+FPl7r/jGfC3DZQxZFTwfiSFK0/tEEIEiwCXqpk8bYW2XgnfLWrp4U5T7A==
X-Received: by 2002:a17:906:5d05:: with SMTP id g5mr27915075ejt.489.1615884158963;
        Tue, 16 Mar 2021 01:42:38 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id f9sm527646edq.43.2021.03.16.01.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 01:42:38 -0700 (PDT)
Date:   Tue, 16 Mar 2021 10:42:37 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: dsa: mv88e6xxx: Provide generic VTU
 iterator
Message-ID: <20210316084237.l6q4p3peonowshds@skbuf>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
 <20210315211400.2805330-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315211400.2805330-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 10:13:56PM +0100, Tobias Waldekranz wrote:
> @@ -2184,25 +2230,7 @@ static int mv88e6xxx_port_db_dump(struct mv88e6xxx_chip *chip, int port,
>  	if (err)
>  		return err;
>  
> -	/* Dump VLANs' Filtering Information Databases */
> -	vlan.vid = mv88e6xxx_max_vid(chip);
> -	vlan.valid = false;
> -
> -	do {
> -		err = mv88e6xxx_vtu_getnext(chip, &vlan);
> -		if (err)
> -			return err;
> -
> -		if (!vlan.valid)
> -			break;
> -
> -		err = mv88e6xxx_port_db_dump_fid(chip, vlan.fid, vlan.vid, port,
> -						 cb, data);
> -		if (err)
> -			return err;
> -	} while (vlan.vid < mv88e6xxx_max_vid(chip));
> -
> -	return err;
> +	return mv88e6xxx_vtu_walk(chip, mv88e6xxx_port_db_dump_vlan, &ctx);
>  }

Can the mv88e6xxx_port_db_dump_fid(VLAN 0) located above this call be
covered by the same mv88e6xxx_vtu_walk?

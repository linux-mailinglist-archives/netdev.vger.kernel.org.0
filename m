Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EE4228161
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgGUNx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgGUNx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:53:58 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70ACAC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 06:53:58 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f139so2949822wmf.5
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 06:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Faa8BtHa5EVfb7bxqb5m7iSDK0uSUb00BYa3wpBGB90=;
        b=oOKQXTAYcShrm6rjYBnIACsMZz+WjVXIyQDqrMik0x+sc92MA7rfS06WxrQr5u8nIl
         aK8CEFinFGjp/ij2jaQLBJ8SlIyDYTGT3EuJTlWDIW0M/rZzo0cEbvAmBkQ++EADdz1L
         eZx7x1Las6nvGfGoluppkLUA/jZiayKdBo3Zci+4jd9J1j9edJvFw6MssfArqOgIwami
         EXT9dyH1Ym07xcc7zk0FZJQGdeVwoFSWFi5s7Op6AgVFJqf5Ib6NAfzeVlcm89rP11HU
         aT4lQrVJ8eHd3LnxmQT9nzpxq2EXJJguTXhovHFFTfHxecmYWJpsS9iwncM3Qvs0E2qn
         JYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Faa8BtHa5EVfb7bxqb5m7iSDK0uSUb00BYa3wpBGB90=;
        b=MX/fS9Fyx6mrIp4UptqE1Oh7LnBb6XQVj/xQ1IFabYdcobQquENkRDK8xguVUjv7ot
         mlZ4/OaSy81j5l+bf0dl7Pg/A1EYRZ2hnS0wncxKjJuNyWXFMRQNdEOdgQIcyv/PAx1D
         Qxv8vJAyfFF/T7hWbHqwd0t1BRKdcWMyXE3q06vhPAgbly6ncpsAGoENig2Oiezp3oWG
         I8NVONbxw0OVmU9EOU5VzJuYwA1Bs+AE2VwKRK2b9r/69xjEaQuBCHI3HuYRZwso7tLc
         OZFMt9nzpwbwqcutYIfhsATUip6ZYrZ/8guXmKvVy7y4H+EGd4cnuyANnj8E5z41MWrd
         JpGg==
X-Gm-Message-State: AOAM532MvOj/CA2WRwjQMZIQt4N4qf3Qdgwhoey9MfbBEfMPySv6aW1u
        7//pj+GOPmgvNrCoeaZ/9R46Zw==
X-Google-Smtp-Source: ABdhPJw7Lt5F1GOH7wjfTyj707oOT5peeAcndjIi5bJZG15NpN2ZIsdHUR1TSwD7N3Z85hHSFf2FGA==
X-Received: by 2002:a1c:7416:: with SMTP id p22mr4180054wmc.32.1595339637236;
        Tue, 21 Jul 2020 06:53:57 -0700 (PDT)
Received: from localhost (ip-89-103-111-149.net.upcbroadband.cz. [89.103.111.149])
        by smtp.gmail.com with ESMTPSA id 33sm41380162wri.16.2020.07.21.06.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 06:53:56 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:53:56 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
Message-ID: <20200721135356.GB2205@nanopsycho>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717183541.797878-7-jacob.e.keller@intel.com>
 <20200720100953.GB2235@nanopsycho>
 <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 20, 2020 at 05:51:59PM CEST, kubakici@wp.pl wrote:
>On Mon, 20 Jul 2020 12:09:53 +0200 Jiri Pirko wrote:
>> This looks odd. You have a single image yet you somehow divide it
>> into "program" and "config" areas. We already have infra in place to
>> take care of this. See DEVLINK_ATTR_FLASH_UPDATE_COMPONENT.
>> You should have 2 components:
>> 1) "program"
>> 2) "config"
>> 
>> Then it is up to the user what he decides to flash.
>
>99.9% of the time users want to flash "all". To achieve "don't flash
>config" with current infra users would have to flash each component 

Well you can have multiple component what would overlap:
1) "program" + "config" (default)
2) "program"
3) "config"



>one by one and then omit the one(s) which is config (guessing which 
>one that is based on the name).
>
>Wouldn't this be quite inconvenient?

I see it as an extra knob that is actually somehow provides degradation
of components.

>
>In case of MLX is PSID considered config?

Nope.

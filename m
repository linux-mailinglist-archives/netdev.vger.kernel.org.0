Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034433E0B5F
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 02:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbhHEAnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 20:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbhHEAnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 20:43:40 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FF6C061765;
        Wed,  4 Aug 2021 17:43:26 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id f20-20020a9d6c140000b02904bb9756274cso3448979otq.6;
        Wed, 04 Aug 2021 17:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vGJp7Qm+vWDqCZWodUNjzWvMf7Y6QRcUPiH81G9CbDc=;
        b=sQkknu+u8jaaB0OcDj6EoRyQO9F7NA9Ud0m6EJ+C2C0ePjqe9hNCnkVkIhC0pjyIZP
         W97xALtifJROfE1qpdGxVX7t01xf3OUl9KJgqZPDl5v3D6FxuuVF0VVTvppzKi5XXtsE
         4ed0zRbT1+oeflIJYRddJz7nhap0Itb932QISt28jF0AZkADODWGr6pauN4688v0ms2M
         NL3LcQi8aY7fs3XjiOEGT3q7TyCWHHsWz+H/9xBY3cUpaylthKBA06O7oI6ZQSb+zUI6
         Oxd5Gj32aEAFvzY1Eyn/QvPv46r/JIqp3cYCy2IUn4Zc1ZseVwoPv3/E1/xwjWiG8rg8
         wnYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vGJp7Qm+vWDqCZWodUNjzWvMf7Y6QRcUPiH81G9CbDc=;
        b=FQrKE+YzCbPSjcvmbnT5R4B3W06ne9HeJ411vB7puHt/g9TDpTGT9yGy28Qbiu759q
         DjT360hUrVXMqHAkIr7w2fLx6ooXfuM9xW3YaTm2oE9xs/PjfhaVOUQ8aET8/QitDBwB
         b9Rnle31I+EVeqA93eyRNYcCjv0d9DthNbHkT+UoIgo7eu8QLZzZ7wFmBR+qrbNGIRN7
         4vLllgemqCp/UG0FQno1Xh55syZE1NzVJbQoFSihrsG6SWVdKs2I85xBi+JNZfDOL19z
         vLV8Pd57VrZpPnbcKzu95+Z00bCinIt7m9M62g9R/XKwzAvwkKXlkHJc4hLnUNicoLAT
         EyLQ==
X-Gm-Message-State: AOAM532rvqI9OOCdW32t/99cFUmr4sR2x4kklFoC6H9ycFv4FJ/RBeXM
        /iuo/f0q9CI9vYKgX68VbZxIBs2vwviBqw==
X-Google-Smtp-Source: ABdhPJz7SOE1TlkK7NDXzrAWjDSQbCEogTY9jw9xb8Kf3WqLv/BBMLwqDVgoBq0L3LxOht5ewMZflQ==
X-Received: by 2002:a9d:63d3:: with SMTP id e19mr1640471otl.147.1628124205501;
        Wed, 04 Aug 2021 17:43:25 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id v13sm563634ook.40.2021.08.04.17.43.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 17:43:24 -0700 (PDT)
Subject: Re: [PATCH net-next 03/21] ethtool, stats: introduce standard XDP
 statistics
To:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
 <20210803163641.3743-4-alexandr.lobakin@intel.com>
 <20210803134900.578b4c37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ec0aefbc987575d1979f9102d331bd3e8f809824.camel@kernel.org>
 <20210804053650.22aa8a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <43e91ce1-0f82-5820-7cac-b42461a0311a@gmail.com>
 <20210804094432.08d0fa86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d21933cb-9d24-9bdd-cf18-e5077796ddf7@gmail.com>
 <11091d33ff7803257e38ee921e4ba9597acfccfc.camel@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4b2358e1-a802-b0ab-129d-1432f49c46ec@gmail.com>
Date:   Wed, 4 Aug 2021 18:43:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <11091d33ff7803257e38ee921e4ba9597acfccfc.camel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/21 12:27 PM, Saeed Mahameed wrote:
> 
>> I just ran some quick tests with my setup and measured about 1.2%
>> worst
> 
> 1.2% is a lot ! what was the test ? what is the change ?

I did say "quick test ... not exhaustive" and it was definitely
eyeballing a pps change over a small time window.

If multiple counters are bumped 20-25 million times a second (e.g. XDP
drop case), how measurable is it? I was just trying to ballpark the
overhead - 1%, 5%, more? If it is <~ 1% then there is no performance
argument in which case let's do the right thing for users - export via
existing APIs.

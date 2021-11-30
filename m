Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D32463D2C
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 18:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239341AbhK3RtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbhK3RtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:49:16 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFDDC061574;
        Tue, 30 Nov 2021 09:45:56 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id be32so42705852oib.11;
        Tue, 30 Nov 2021 09:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XQDjVUqMHzhsaLSX72FpGvCv4WfW3bJNSIFmp2dV73Y=;
        b=i6RIwWLgsrCTl7jGOwupWsLU63T4N22hibLuzIctrW/RPwt8MAAmE3hpHlxS62fgGH
         yf83zD2tYKiIL0uvvLSDiG/MtLgPVRNVam85g9P/LDl4DDIA5IKrUdVngb3C4BM6U7/N
         /rbGn3p9sWO4MfjS9kGWlInpqhsIu+Te3zIhSXlyHUoreFE77oEecisKbn+41TXA8Xih
         W8JQjZKx2NIInNntdipij+O9RiUv1fWvXzCc2qhJm8Xa+X5oYxUMNFiFojIII9cxydFm
         J3jvQ1ur3a7M/6jYdHRPkXQ5JA5eeNR0ZuEqNY7/UeJarOJmzBVPDihzZaDtBl8lLAzi
         ELRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XQDjVUqMHzhsaLSX72FpGvCv4WfW3bJNSIFmp2dV73Y=;
        b=r+mdWKr0I8EzB8EQ7n+IOljAHW8FN6atGKOPZB3zmbqcoohM1L6sOrVPWXyKU1GTbD
         r/frXHQwCqgQdMgT+S+2s410fwH7OvdlnMhx1oPJ7fhVc3a4gOjhdHScZ+yc1CyoR00J
         cBvQBdjwoCmHRyoWb8nzxaFTFxZnJA2S414js2v3s9iwxW4TMER1GbrkVeUxFoxtgw/V
         FScgzCN0qQgptcC4a+JELwMdk067XJ5IKNM4Yj67rfOGonyN7ijD/Wl6v5sXR9Fv3Opf
         u2UwKjtxT0VmSLIGG1ZkQmejJJO3YsTYo6O/oyfjeo9YslS/HSTkcfzFY/0FyGWq+JPO
         H6dQ==
X-Gm-Message-State: AOAM531t+wwDUk7mf0AHLyMUn95qX9T/ZkWGrobjovQuVrVI1DeljG/i
        10AOUq1lIjFqEyTtUWh6MZA=
X-Google-Smtp-Source: ABdhPJzn1aa/vW8m1o9/rqJ9jY1Q1riv+YPz8e4+I2zQ9i+vkgbHrskkZ/2npSiRO579znJxNKX/mA==
X-Received: by 2002:a54:4614:: with SMTP id p20mr385770oip.39.1638294356099;
        Tue, 30 Nov 2021 09:45:56 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id a17sm3858966oiw.43.2021.11.30.09.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 09:45:55 -0800 (PST)
Message-ID: <85d2b974-f596-f36e-099f-a698b6be464e@gmail.com>
Date:   Tue, 30 Nov 2021 10:45:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2 net-next 00/26] net: introduce and use generic XDP
 stats
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211130155612.594688-1-alexandr.lobakin@intel.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211130155612.594688-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/21 8:56 AM, Alexander Lobakin wrote:
> Rest:
>  - don't create a separate `ip` command and report under `-s`;

Reporting XDP stats under 'ip -s' is not going to be scalable from a
readability perspective.

ifstat (misc/ifstat.c) has support for extended stats which is where you
are adding these.

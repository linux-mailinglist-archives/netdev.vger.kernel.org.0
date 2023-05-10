Return-Path: <netdev+bounces-1486-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D7B06FDF7A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:03:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1ECD1C20DA9
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265D012B9E;
	Wed, 10 May 2023 14:03:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B59C20B54
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:03:05 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED52A30D4
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:03:02 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f4271185daso33270425e9.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683727381; x=1686319381;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FVw999dvPhGd2eXB/JRLP7sRYq7BRgrObABU4ZS8Wlw=;
        b=H2IlWHjix7NMm+c0BhDtJyUQYjWXQBOm633ngDNQ+nMVx6IgZ17bI8IZKxZnbduVTZ
         GJugt4wsV8d5JfZNCOC7eDVtnp0JihzKqYH06vt5m+5l5BwLE6vWVf6dbriRs1gTo44U
         +egSK0cE3qmOV2AwFvb4C1H0K6B7yWmN4G5xUwnICHpEKDFSjJuT05Bo3GHk8338+UrF
         l4+BpWB1XyiI5C8Ho4Zz+O3t+Oeox4/n9yrLCChZ2InndXV8z57PMN/WMR6zossEpaJ3
         CliyMTYQvRjyfQJiTzQfG+3aLwpu8uvBTANZoS4k+avqHefOG3adgwupF0SCQVXERhhx
         T9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683727381; x=1686319381;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FVw999dvPhGd2eXB/JRLP7sRYq7BRgrObABU4ZS8Wlw=;
        b=ha+i7l4/HWxF786MSGPcghSniHtq/nkwJ6XmxHLmjEtNswzDjKPKdf59oN5eguQLmX
         +jwtSLVXH7HozlzQJULk3mUc8Y8ruFsTI4kaztpggd0L7SyuYTg7IyOrUTAQcCmF+msm
         IKfKlCEXfVUU+YhBbcrwv24k6aT621/evhmfKOVw3OM8YahvouERdRuK/A+UK7jXJk/h
         eJPGW5VYAXpSi+Y7Z+k6Rcbnfna17G3U1zDALZpQv9xXGzEdOvYBj1ocXCzo+paM/Pzp
         pabDi5tP9PIBcjKh35oHYMEw/hwaz43d6cfOMtihnyY0JdMbDSiiF6NUsDfH4JtYUXRr
         SUNQ==
X-Gm-Message-State: AC+VfDy0c1tsX6hksQAVUJtrG/snoNRbUMnkeJ/OO9K3YcBCTfzqxHs9
	LtMilT6AKX8JkiLVF/AzqHtFe7eeK0D37CpY
X-Google-Smtp-Source: ACHHUZ7DVRjE2srLb577/YwOwv00cCp2AWsmsibzILg/TqsVqnUaMRAhl7l/td98S737ns2j5TQojg==
X-Received: by 2002:adf:f3c9:0:b0:306:3319:e432 with SMTP id g9-20020adff3c9000000b003063319e432mr12584806wrp.18.1683727381085;
        Wed, 10 May 2023 07:03:01 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id e15-20020a5d4e8f000000b0030629536e64sm17530190wru.30.2023.05.10.07.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 07:03:00 -0700 (PDT)
Date: Wed, 10 May 2023 17:02:58 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Daniel Golle <daniel@makrotopia.org>, DENG Qingfang <dqfext@gmail.com>,
	Greg Ungerer <gerg@kernel.org>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>, mithat.guner@xeront.com,
	erkin.bozoglu@xeront.com, bartel.eerdekens@constell8.be,
	netdev <netdev@vger.kernel.org>
Subject: Re: MT7530 bug, forward broadcast and unknown frames to the correct
 CPU port
Message-ID: <20230510140258.44oobynufb3auzw2@skbuf>
References: <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <20230429173522.tqd7izelbhr4rvqz@skbuf>
 <680eea9a-e719-bbb1-0c7c-1b843ed2afcd@arinc9.com>
 <20230429185657.jrpcxoqwr5tcyt54@skbuf>
 <d3a73d34-efd7-2f37-1362-9a2fe5a21592@arinc9.com>
 <20230501100930.eemwoxmwh7oenhvb@skbuf>
 <ZE-VEuhiPygZYGPe@makrotopia.org>
 <839003bf-477e-9c91-3a98-08f8ca869276@arinc9.com>
 <21ce3015-b379-056c-e5ca-8763c58c6553@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21ce3015-b379-056c-e5ca-8763c58c6553@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 10:59:36AM +0200, Arınç ÜNAL wrote:
> > You seem to be rather talking about MT7530 while I think preferring port 6
> > would benefit MT7531BE the most.
> > 
> > Can you test the actual speed with SGMII on MT7531? Route between two ports and
> > do a bidirectional iperf3 speed test.
> > 
> > SGMII should at least provide you with 2 Gbps bandwidth in total in a
> > router-on-a-stick scenario which is the current situation until the changing
> > DSA conduit support is added.
> > 
> > If we were to use port 5, download and upload speed would be capped at 500
> > Mbps. With SGMII you should get 1000 Mbps on each.
> 
> I tested this on Daniel's Banana Pi BPI-R3 which has got an MT7531AE switch.
> I can confirm I get more than 500 Mbps for RX and TX on a bidirectional
> speed test.
> 
> [SUM][RX-S]   0.00-18.00  sec  1.50 GBytes   715 Mbits/sec    receiver
> 
> [SUM][TX-S]   0.00-18.00  sec  1.55 GBytes   742 Mbits/sec  6996     sender
> 
> The test was run between two computers on different networks, 192.168.1.0/24
> and 192.168.2.0/24, both computers had static routes to reach each other. I
> tried iperf3 as the server and client on both computers with similar
> results.
> 
> This concludes preferring port 6 is practically beneficial for MT7531BE.

One thing you seem to not realize is that "1 Gbit/sec full duplex" means
that there is 1Gbps of bandwidth in the TX direction and 1 Gbps of
bandwidth of throughput in the RX direction. So, I don't see how your
test proves anything, since a single SGMII full duplex link to the CPU
should be able to absorb your 715 RX + 742 TX traffic just fine.


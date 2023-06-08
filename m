Return-Path: <netdev+bounces-9118-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A9EC7275DE
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 05:43:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E2F928162A
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 03:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8F6111A;
	Thu,  8 Jun 2023 03:43:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0286D10EF
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 03:43:37 +0000 (UTC)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7117926A2
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:43:36 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-65299178ac5so83390b3a.1
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 20:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686195816; x=1688787816;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VX80H3xdEP4RRqR3vLXeVXX6EhAP/SF458obWkJkoHA=;
        b=gH/iD45XGHgFUSy28+QXlfYugWyN0aYa7xANCgmyjsffa4HG++mSdkzfP9PE8bvQgd
         aLtohjk6xB+KR9gtfK8Y9FuxRrHVyyiMCg5Q48gHQuUpJ6GBADFBe7WcL/554ALnQ5rw
         RlfqoXMjXNmjztnXCp+zwayf2bxzrVETVhsBF8kWVGeVWv+rtyaPXz1SA6gWI3MiSbCP
         SKuULNJiBEjHrGx1Uzh1jrKN1VxrRlHu2syWHixYjzlsZRaYra7A+4O67W3gcvNczZNQ
         R5zfu3U5vNZKYf6z6czq9yS+mgunwcZFp8gWjDLHF/dvsxBZI71TeoEjQcFOu9CE+3ad
         oyWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686195816; x=1688787816;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VX80H3xdEP4RRqR3vLXeVXX6EhAP/SF458obWkJkoHA=;
        b=cmRM19A4pWmyaenDC3DdzLQ/EVZPr4NWAr/GZFd/VnXPN1YypRGBhTm6QIV5EJVKBo
         kcRl4vsldDRbf7bi+vUIdXKYCVxwLgxALXcQqL5pOz5oSLXBHWczzAu7S2iLUEMsfJAt
         azxeeFasi9foQTWwdunpCar4HfZ+emoMSfPdf842pTK3ipuVoWG1l/wWS0DQnpgu76Bz
         m9oelNGFC2rGcfjEAOLkwi9JzlfcMEZzI5znkDW8o7XnqBYKWpc4wH4uKpZKPV0EX9d8
         n7qLlXg80M11yxwU/0msiqrRUC8i+usr2L4rAbX33IRotgP8vSCzcjJ3Dpqaw1QT7rSK
         NHUg==
X-Gm-Message-State: AC+VfDyS+A7+1mOGckjvYhzoycLsWB3QBs+oaBYn6YTgodWMYHxmE9JN
	7eTPDfZqfbE9SMg/wgOH2d5nmKOaePWKwA==
X-Google-Smtp-Source: ACHHUZ7WMDX0cAdfBTWTdS0r5PUfU6nENj94chz0EYV1G7u1B8M+nq2JsQJoc8KnvR2fTRVF+Xurow==
X-Received: by 2002:a05:6a21:3943:b0:10c:4e7f:1a5a with SMTP id ac3-20020a056a21394300b0010c4e7f1a5amr5010084pzc.49.1686195815838;
        Wed, 07 Jun 2023 20:43:35 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g5-20020a63e605000000b00528db73ed70sm233139pgh.3.2023.06.07.20.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 20:43:35 -0700 (PDT)
Date: Thu, 8 Jun 2023 11:43:31 +0800
From: Hangbin Liu <liuhangbin@gmail.com>
To: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: netdev@vger.kernel.org
Subject: Re: [Discuss] IPv4 packets lost with macvlan over bond alb
Message-ID: <ZIFOY02zi9FZ+aNh@Laptop-X1>
References: <ZHmjlzbRi0nHUuTU@Laptop-X1>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHmjlzbRi0nHUuTU@Laptop-X1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jay, any thoughts?

Thanks
Hangbin
On Fri, Jun 02, 2023 at 04:09:00PM +0800, Hangbin Liu wrote:
> Hi Jay,
> 
> It looks there is an regression for commit 14af9963ba1e ("bonding: Support
> macvlans on top of tlb/rlb mode bonds"). The author export modified ARP to
> remote when there is macvlan over bond, which make remote add neighbor
> with macvlan's IP and bond's mac. The author expect RLB will replace all
> inner packets to correct mac address if target is macvlan, but RLB only
> handle ARP packets. This make all none arp packets macvlan received have
> incorrect mac address, and dropped directly.
> 
> In short, remote client learned macvlan's ip with bond's mac. So the macvlan
> will receive packets with incorrect macs and dropped.
> 
> To fix this, one way is to revert the patch and only send learning packets for
> both tlb and alb mode for macvlan. This would make all macvlan rx packets go
> through bond's active slave.
> 
> Another way is to replace the bond's mac address to correct macvlan's address
> based on the rx_hashtbl . But this may has impact to the receive performance
> since we need to check all the upper devices and deal the mac address for
> each packets in bond_handle_frame().
> 
> So which way do you prefer?
> 
> Reproducer:
> ```
> #!/bin/bash
> 
> # Source the topo in bond selftest
> source bond_topo_3d1c.sh
> 
> trap cleanup EXIT
> 
> setup_prepare
> bond_reset "mode balance-alb"
> ip -n ${s_ns} addr flush dev bond0
> 
> ip -n ${s_ns} link add link bond0 name macv0 type macvlan mode bridge
> ip -n ${s_ns} link set macv0 up
> 
> # I just add macvlan on the server netns, you can also move it to another netns for testing
> ip -n ${s_ns} addr add ${s_ip4}/24 dev macv0
> ip -n ${s_ns} addr add ${s_ip6}/24 dev macv0
> ip netns exec ${c_ns} ping ${s_ip4} -c 4
> sleep 5
> ip netns exec ${c_ns} ping ${s_ip4} -c 4
> ```
> 
> Thanks
> Hangbin


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789C66CCDA8
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 00:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjC1Wr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 18:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjC1Wr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 18:47:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0890910E9
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 15:47:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85F85619C0
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 22:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8194FC433EF;
        Tue, 28 Mar 2023 22:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680043675;
        bh=yzVPRxzZcDfjuq+84LnXUV2aKcGmzavVssJwFDByBJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i3ePLucnV/3RwAr7ftot+3e+vJ0194epEc2iG/Pa57g2iffNwuyL3bOH0poK5lsot
         WNo2I4P4sc0C9eWfx110dyXpSD9Lv18CUW1Dla6cOy0AkPkt4rsOWvF7fbpVmsaLCu
         YSeztkCw2ApPwnhxFhSJhS+0vzNvm7Q540VCKKHJlOa2LHdwrkOXIYRxXLyC6NpjPK
         xpWtrTF/RCzif3cw/SNK8q9bQK/jHTlS0tvXkJlcMY6GkObw+NJXLVHHL3ElH0YJJ/
         pt4InmFUjRJkczN4bIl4WOFximvKddmPZnI/zntF13b+9n5rJhxiHf51tldqFst/91
         tKpZ01qRf0n3A==
Date:   Tue, 28 Mar 2023 15:47:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
Subject: Re: [PATCH v5 net-next 4/4] sfc: remove expired unicast PTP filters
Message-ID: <20230328154753.6872b87e@kernel.org>
In-Reply-To: <20230327105755.13949-5-ihuguet@redhat.com>
References: <20230327105755.13949-1-ihuguet@redhat.com>
        <20230327105755.13949-5-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Mar 2023 12:57:55 +0200 =C3=8D=C3=B1igo Huguet wrote:
> @@ -313,6 +318,7 @@ struct efx_ptp_data {
>  	struct efx_ptp_event_rx rx_evts[MAX_RECEIVE_EVENTS];
>  	struct workqueue_struct *workwq;
>  	struct work_struct work;
> +	struct delayed_work cleanup_work;
>  	bool reset_required;
>  	struct list_head rxfilters_mcast;
>  	struct list_head rxfilters_ucast;

kdoc update missing

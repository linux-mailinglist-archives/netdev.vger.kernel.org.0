Return-Path: <netdev+bounces-3713-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A72170866B
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:10:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38C871C20DEE
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B00624E94;
	Thu, 18 May 2023 17:10:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A18223C90
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 17:10:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B0C9F
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684429839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wdUVVT/Gh0h3a0M3UuaFKXpOqMtLr7CTYjRZtfYWYb0=;
	b=ifR8dwf67YZDkXGkr2DOhbrhIt/1YYBAmOuYRsP/IwuzvevSb5Y7tKpcKrA5KxtDdHvgLO
	1C8ENLgkprtShFYJQobeKT2OXlXS3CIPWj8Aei1BrKeNvX2qTgdk1Kteio+GkoLoF8qKFE
	kMAgfndU3Y9DlcLS6QNn15gEdsL4/1s=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-308-xCiwi_SgM664Ca-OkDtM4Q-1; Thu, 18 May 2023 13:10:38 -0400
X-MC-Unique: xCiwi_SgM664Ca-OkDtM4Q-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4ef455ba61cso1643011e87.0
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:10:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684429837; x=1687021837;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wdUVVT/Gh0h3a0M3UuaFKXpOqMtLr7CTYjRZtfYWYb0=;
        b=LyCW474XK2sOY0Z8cPsjwUgUc2TBoAYZsxgRv52prDPSnAGe7gDJVN1dQk2kZEP6kc
         e14oJp8AYlNECQTykfkaG5+eOwsXJOy4zSvDja1OAu8lMp5S1bXdxVmWEWDjPdpw6Vz5
         9nlmvBdVThMVyWvfE9SCngS8MeszEZ2NqYxhVYrbGFaGhvloNNDz1KbHqIVWePy2XLJV
         x02W2IM4L6TguuP37a65oBw0sX2Gy9qmHv/58stAtpwKTvgJlxfbqlt4tjT12lhfYzXO
         TcRGWmzSsqePktKP7/57kWcOaRgucQnKDsflsh3qNmPSuLqFnKG6T8w8sIDJFPZLKKp5
         HPiw==
X-Gm-Message-State: AC+VfDzk09NjVqUg+Bdbl4HOjjtEI1wsAfSFlwSqkoGaCb3tFzJNjjVS
	2bAAc86KLdC9LFaLMiVuW1Cjp0Oj61ppxovn4L9yQOhGTtWh6UVopTenmXQdWTD1/8pIGO6MTCA
	hOuYxqPzOLwnJ68GX
X-Received: by 2002:ac2:47f4:0:b0:4ef:f3bf:93a6 with SMTP id b20-20020ac247f4000000b004eff3bf93a6mr1320493lfp.51.1684429836857;
        Thu, 18 May 2023 10:10:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5mJQAyU8eMFAPoYUR83fXtizp93jbZcxuQoZeZF89CQUd8JRlNhQiXgN4K5QbAUDfWVC4/xQ==
X-Received: by 2002:ac2:47f4:0:b0:4ef:f3bf:93a6 with SMTP id b20-20020ac247f4000000b004eff3bf93a6mr1320484lfp.51.1684429836447;
        Thu, 18 May 2023 10:10:36 -0700 (PDT)
Received: from redhat.com ([2a02:14f:175:3e4d:6703:27b9:6f74:5282])
        by smtp.gmail.com with ESMTPSA id c3-20020a197603000000b004f13eca769esm314397lff.82.2023.05.18.10.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 10:10:35 -0700 (PDT)
Date: Thu, 18 May 2023 13:10:29 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc: Emil Tantilov <emil.s.tantilov@intel.com>,
	intel-wired-lan@lists.osuosl.org, shannon.nelson@amd.com,
	simon.horman@corigine.com, leon@kernel.org, decot@google.com,
	willemb@google.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: Re: [PATCH iwl-next v4 00/15] Introduce Intel IDPF driver
Message-ID: <20230518130452-mutt-send-email-mst@kernel.org>
References: <20230508194326.482-1-emil.s.tantilov@intel.com>
 <20230512023234-mutt-send-email-mst@kernel.org>
 <6a900cd7-470a-3611-c88a-9f901c56c97f@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a900cd7-470a-3611-c88a-9f901c56c97f@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 09:19:31AM -0700, Samudrala, Sridhar wrote:
> 
> 
> On 5/11/2023 11:34 PM, Michael S. Tsirkin wrote:
> > On Mon, May 08, 2023 at 12:43:11PM -0700, Emil Tantilov wrote:
> > > This patch series introduces the Intel Infrastructure Data Path Function
> > > (IDPF) driver. It is used for both physical and virtual functions. Except
> > > for some of the device operations the rest of the functionality is the
> > > same for both PF and VF. IDPF uses virtchnl version2 opcodes and
> > > structures defined in the virtchnl2 header file which helps the driver
> > > to learn the capabilities and register offsets from the device
> > > Control Plane (CP) instead of assuming the default values.
> > 
> > So, is this for merge in the next cycle?  Should this be an RFC rather?
> > It seems unlikely that the IDPF specification will be finalized by that
> > time - how are you going to handle any specification changes?
> 
> Yes. we would like this driver to be merged in the next cycle(6.5).
> Based on the community feedback on v1 version of the driver, we removed all
> references to OASIS standard and at this time this is an intel vendor
> driver.
> 
> Links to v1 and v2 discussion threads
> https://lore.kernel.org/netdev/20230329140404.1647925-1-pavan.kumar.linga@intel.com/
> https://lore.kernel.org/netdev/20230411011354.2619359-1-pavan.kumar.linga@intel.com/
> 
> The v1->v2 change log reflects this update.
> v1 --> v2: link [1]
>  * removed the OASIS reference in the commit message to make it clear
>    that this is an Intel vendor specific driver

Yes this makes sense.


> Any IDPF specification updates would be handled as part of the changes that
> would be required to make this a common standards driver.


So my question is, would it make sense to update Kconfig and module name
to be "ipu" or if you prefer "intel-idpf" to make it clear this is
currently an Intel vendor specific driver?  And then when you make it a
common standards driver rename it to idpf?  The point being to help make
sure users are not confused about whether they got a driver with
or without IDPF updates. It's not critical I guess but seems like a good
idea. WDYT?

-- 
MST



Return-Path: <netdev+bounces-3967-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B962A709DA5
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15D6C281D57
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:13:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 272B2125D0;
	Fri, 19 May 2023 17:13:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B05125C5
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:13:24 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40380139
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:13:22 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f42397f41fso1875e9.1
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684516401; x=1687108401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s6WK+xWrHQ+JTxtp2AXeRwdsSH3wHXCWRGYlZ7c1BNA=;
        b=lCYt0lkUpB9s7ZkslzFYXwgknS4qqvt8nSYrarjTslt+PDhmXqKCvJe5ZtRNE8EeIA
         QdxHnN+CBBnZbvzcBnBuPKe9OuXsbf/SGVGuJsv5a3iTwb+JnvcLDTbhK29mhPdi+v2h
         nOX3PM/wy74Rz34VnWwjI+E504H58SsEZOvPT7q5VVWgK0/kTAQ3cXz3mpJfyi8PyjJj
         mpqitaTd8k+xWnME0lrTVLAiKyr0FVmu1Fw6ACfWDlIBNeKhEiVe7vdMPbENTpjs2fz6
         G8ITujx4bbbGZqWot10rNiUOV83Wu9uASVW2HcbQFwtksa7oUTkwXEDDl5WCAPmzfcKJ
         5L2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684516401; x=1687108401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s6WK+xWrHQ+JTxtp2AXeRwdsSH3wHXCWRGYlZ7c1BNA=;
        b=VAdsyAluhOMDWgtg4pAx62QAftOim/RqGaNKUSzDOY4N8qp9APdsfQWf+sLXiDGWJD
         VMP7NvAvfgurNX5Ht6k/yAPSOSXX1kixAwVR15XTdvsVcxqZWXP2rLCWjshNtjRlzbVH
         NYIxOu5kG0Dita+rdFzPzQ3UAAlzypGsh34ufB4oD6OuSEl11mF2tYILBdcILtq8VUkH
         +5h0tKvZ8eIr4s6/lfHnqCiM1J/+up9yFOad9DVydeWAqFAtvfxrpp8no7Z5bAEZzckL
         qsrm3srrE08nTXh3O7UXGaZLKxwej68Vq0ipM1VPzYgVUm5LD0vD3Jrl5yYLG1B+o7mK
         v3qg==
X-Gm-Message-State: AC+VfDzjhKqjEHv9082/gu2ybIPEsPUHxn9b7VObEeXvFL6y40OAKge6
	Wny7yKfHz/o7eVSnWmIuPfNHWiY7G3Wnwck/AvG4hA==
X-Google-Smtp-Source: ACHHUZ5hxQ9IcqaGkyOL1r+DTQU2ZAEAdORZv/jidrV9JGcURc4fHU4i/zAWrvZE323XlSufcz9ryYZf13pgCpkdf7w=
X-Received: by 2002:a05:600c:500b:b0:3f3:3855:c5d8 with SMTP id
 n11-20020a05600c500b00b003f33855c5d8mr198993wmr.6.1684516400646; Fri, 19 May
 2023 10:13:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230508194326.482-1-emil.s.tantilov@intel.com>
 <20230512023234-mutt-send-email-mst@kernel.org> <6a900cd7-470a-3611-c88a-9f901c56c97f@intel.com>
 <20230518130452-mutt-send-email-mst@kernel.org> <dba3d773-0834-10fe-01a1-511b4dd263e5@intel.com>
 <7969d09e-2b77-c1a7-0e38-f10d61c83638@amd.com>
In-Reply-To: <7969d09e-2b77-c1a7-0e38-f10d61c83638@amd.com>
From: Willem de Bruijn <willemb@google.com>
Date: Fri, 19 May 2023 13:12:43 -0400
Message-ID: <CA+FuTSfUvSDFZ95d8urmEcRLMU6pnb_t-7OwV-dcJPU=mAEnkg@mail.gmail.com>
Subject: Re: [PATCH iwl-next v4 00/15] Introduce Intel IDPF driver
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Emil Tantilov <emil.s.tantilov@intel.com>, intel-wired-lan@lists.osuosl.org, 
	simon.horman@corigine.com, leon@kernel.org, decot@google.com, 
	jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	netdev@vger.kernel.org, "Singhai, Anjali" <anjali.singhai@intel.com>, 
	"Orr, Michael" <michael.orr@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 12:17=E2=80=AFPM Shannon Nelson <shannon.nelson@amd=
.com> wrote:
>
> On 5/18/23 4:26 PM, Samudrala, Sridhar wrote:
> > On 5/18/2023 10:10 AM, Michael S. Tsirkin wrote:
> >> On Thu, May 18, 2023 at 09:19:31AM -0700, Samudrala, Sridhar wrote:
> >>>
> >>>
> >>> On 5/11/2023 11:34 PM, Michael S. Tsirkin wrote:
> >>>> On Mon, May 08, 2023 at 12:43:11PM -0700, Emil Tantilov wrote:
> >>>>> This patch series introduces the Intel Infrastructure Data Path
> >>>>> Function
> >>>>> (IDPF) driver. It is used for both physical and virtual functions.
> >>>>> Except
> >>>>> for some of the device operations the rest of the functionality is =
the
> >>>>> same for both PF and VF. IDPF uses virtchnl version2 opcodes and
> >>>>> structures defined in the virtchnl2 header file which helps the dri=
ver
> >>>>> to learn the capabilities and register offsets from the device
> >>>>> Control Plane (CP) instead of assuming the default values.
> >>>>
> >>>> So, is this for merge in the next cycle?  Should this be an RFC rath=
er?
> >>>> It seems unlikely that the IDPF specification will be finalized by t=
hat
> >>>> time - how are you going to handle any specification changes?
> >>>
> >>> Yes. we would like this driver to be merged in the next cycle(6.5).
> >>> Based on the community feedback on v1 version of the driver, we
> >>> removed all
> >>> references to OASIS standard and at this time this is an intel vendor
> >>> driver.
> >>>
> >>> Links to v1 and v2 discussion threads
> >>> https://lore.kernel.org/netdev/20230329140404.1647925-1-pavan.kumar.l=
inga@intel.com/
> >>> https://lore.kernel.org/netdev/20230411011354.2619359-1-pavan.kumar.l=
inga@intel.com/
> >>>
> >>> The v1->v2 change log reflects this update.
> >>> v1 --> v2: link [1]
> >>>   * removed the OASIS reference in the commit message to make it clea=
r
> >>>     that this is an Intel vendor specific driver
> >>
> >> Yes this makes sense.
> >>
> >>
> >>> Any IDPF specification updates would be handled as part of the
> >>> changes that
> >>> would be required to make this a common standards driver.
> >>
> >>
> >> So my question is, would it make sense to update Kconfig and module na=
me
> >> to be "ipu" or if you prefer "intel-idpf" to make it clear this is
> >> currently an Intel vendor specific driver?  And then when you make it =
a
> >> common standards driver rename it to idpf?  The point being to help ma=
ke
> >> sure users are not confused about whether they got a driver with
> >> or without IDPF updates. It's not critical I guess but seems like a go=
od
> >> idea. WDYT?
> >
> > It would be more disruptive to change the name of the driver. We can
> > update the pci device table, module description and possibly driver
> > version when we are ready to make this a standard driver.
> > So we would prefer not changing the driver name.
>
> More disruptive for who?
>
> I think it would be better to change the name of the one driver now
> before a problem is created in the tree than to leave a point of
> confusion for the rest of the drivers to contend with in the future.

This discussion is premised on the idea that the drivers will
inevitably fork, with an Intel driver and a non-backward compatible
standardized driver.

Instead, I expect that the goal is that the future standardized driver
will iterate and support additional features. But that the existing
hardware will continue to be supported, if perhaps with updated
firmware.

IDPF from the start uses feature negotiation over virtchannel to be
highly configurable. A future driver might deprecate older feature
(variants), while either still continue to support those or require
firmware updates to match the new version.

Even if the device API would break in a non-backward compatible way,
the same driver can support both versions. Virtio is an example of
this.

If I'm wrong and for some reason two drivers would have to be
supported, then I'm sure we can figure out a suffix or prefix to the
standard driver that separates it from the existing one.


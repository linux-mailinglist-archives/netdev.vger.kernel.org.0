Return-Path: <netdev+bounces-10805-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED5A97305DC
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:18:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A998028147C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 521602EC30;
	Wed, 14 Jun 2023 17:17:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E0E7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:17:57 +0000 (UTC)
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258EE270F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:17:48 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5439aafb633so4868768a12.2
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686763067; x=1689355067;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+xmQsd+VW6PRvNbCB6GvIbt2csEbSzZV1KR6dYbiTow=;
        b=Vmjx3Xi6D/fTBM6JKBDz+I0Hb+SHU1DwPsNJBjn0w0kmOCNeAE/Sr9yTwxisKHfdb/
         iAAW0IDHLmBzr/rGz+pHP5N6zwboReHuQaKjtCLCBvuNWWJS5naekol8MgKlGEyGggSq
         Z3coCXl6w6tENGDMzTFQZausrbYH9SZjQjHQHl9xTYk7UQfpkfjsq7hCCUoh+pkckcOn
         GB+JkYCsXrVmotp/T7cNPSpHWpxd+61yWiEwmo0+w3BWz2+r7woMz3IuxkbiOZlFsJ6n
         n4cO31ms2KJ1YE+337n+rMnRUMj6lsVAohelZ0Eh5D5h6S2FcAL+bBzxFlRNnhdFXlmO
         p0hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686763067; x=1689355067;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+xmQsd+VW6PRvNbCB6GvIbt2csEbSzZV1KR6dYbiTow=;
        b=UYWVFQkb8oywN3B5KwxdsACvGcCm1uMkuF5+MQCq8wjpTPDtKveiAJd6PInkPdt57M
         aqLR2OB7kHjRyIsiZpij1fkWDOIYzXX6v0r/xsUl5L/vNX/f9HpryGWDEaU+N9lgluGP
         o6a4Rr03D8Nis1EXSTMwLrt83l8Pp0mY0siNmPkScYfaKiT8DI8NW/+ZfI+LnrvEhNMy
         5FHEUlLGHZFVc+jFTRKr/aG5AD8n5PZh6WWu1LdLSYP0NHk+vrMDokEcaaUHkRAzmlz8
         pzC9WLQYTVrcGl3MKb6OEmzk6OhYtWK1dQgazrQLc2mV3PUd1hhD4wkILnkX21UQ6ayu
         CkBA==
X-Gm-Message-State: AC+VfDzrZKlbF1/Hym8ldJZSvRA2rs8t5viuk40FLO0Wig6ibYgNm15E
	qbdXnsFC2sOZZH9zaWIb/Zp4KLA=
X-Google-Smtp-Source: ACHHUZ4hffy6yOKttlVWrLNq/JZf6vbkSaeRM/fZbE1MMNWm5YHyf+fp4wO98xEQT54GhzbADzJnxts=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a65:5a4b:0:b0:53f:2302:8f6a with SMTP id
 z11-20020a655a4b000000b0053f23028f6amr2394269pgs.8.1686763067496; Wed, 14 Jun
 2023 10:17:47 -0700 (PDT)
Date: Wed, 14 Jun 2023 10:17:46 -0700
In-Reply-To: <20230613220507.0678bd02@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <20230613203125.7c7916bc@kernel.org>
 <70d0f31b-3358-d615-a00c-7e664f5f789f@kernel.org> <20230613220507.0678bd02@kernel.org>
Message-ID: <ZIn2OrJhWW8V8yiF@google.com>
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
From: Stanislav Fomichev <sdf@google.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: David Ahern <dsahern@kernel.org>, bpf@vger.kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, 
	haoluo@google.com, jolsa@kernel.org, willemb@google.com, 
	magnus.karlsson@intel.com, bjorn@kernel.org, maciej.fijalkowski@intel.com, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/13, Jakub Kicinski wrote:
> On Tue, 13 Jun 2023 20:54:26 -0700 David Ahern wrote:
> > On 6/13/23 9:31 PM, Jakub Kicinski wrote:
> > > On Mon, 12 Jun 2023 10:23:00 -0700 Stanislav Fomichev wrote:  
> > >> The goal of this series is to add two new standard-ish places
> > >> in the transmit path:
> > >>
> > >> 1. Right before the packet is transmitted (with access to TX
> > >>    descriptors)  
> > 
> > If a device requires multiple Tx descriptors per skb or multibuf frame,
> > how would that be handled within the XDP API?
> > 
> > > I'm not sure that the Tx descriptors can be populated piecemeal.  
> > 
> > If it is host memory before the pidx move, why would that matter? Do you
> > have a specific example in mind?
> 
> I don't mean it's impossible implement, but it's may get cumbersome.
> TSO/CSO/crypto may all need to know where L4 header starts, f.e.
> Some ECN marking in the NIC may also want to know where L3 is.
> So the offsets will get duplicated in each API.
> 
> > > If we were ever to support more standard offload features, which
> > > require packet geometry (hdr offsets etc.) to be described "call
> > > per feature" will end up duplicating arguments, and there will be
> > > a lot of args..
> > > 
> > > And if there is an SKB path in the future combining the normal SKB
> > > offloads with the half-rendered descriptors may be a pain.  
> > 
> > Once the descriptor(s) is (are) populated, the skb is irrelevant is it
> > not? Only complication that comes to mind is wanting to add or remove
> > headers (e.g., tunnels) which will be much more complicated at this
> > point, but might still be possible on a per NIC (and maybe version) basis.
> 
> I guess one can write the skb descriptors first, then modify them from
> the BPF. Either way I feel like the helper approach for Tx will result
> in drivers saving the info into some local struct and then rendering
> the descriptors after. We'll see.

I agree that it's probably the "easiest" option to implement for the
majority of the devices that were designed without much of a
programmability this late in the stack. But maybe some devices can
or at least we can try to influence future designs :-)


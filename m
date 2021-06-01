Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAEF39755B
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhFAOYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:24:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234139AbhFAOYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:24:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622557356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H6DWjqnnNembormebyLn0h1PxGjphy3LNZ6FjCCWWTQ=;
        b=dms7iXRICwDEWhUXSvoaJx+je/NAwaj8687+j+Ykk+pPOIy8/6Vjc4FD67aMXsfOarDPhz
        Reo0HtLCrI4dtTtUb4VD2XWLUL5rX8DrItO23cMM08ICTOJ3tZW6anL9fMWnLKXmWzwDJs
        BlMtVddFdGHh+joMl/26xrOwGvGfydg=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-cIYpprRoM4uaMXoHNVsYkw-1; Tue, 01 Jun 2021 10:22:35 -0400
X-MC-Unique: cIYpprRoM4uaMXoHNVsYkw-1
Received: by mail-il1-f197.google.com with SMTP id o12-20020a056e02188cb02901dbd219e088so5342636ilu.16
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 07:22:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:mime-version:in-reply-to:date
         :message-id:subject:to:cc;
        bh=H6DWjqnnNembormebyLn0h1PxGjphy3LNZ6FjCCWWTQ=;
        b=tZUmnA7XaozaysqxvD5HbJ8vyhhG+2PhLo/R+v+EaOPJndBwCPOnjQRUkk3SILC8wh
         CMJOpWrv8wRpjcD8I7nd+2F+Y4OjgaAIGlGIPrJXRW5VavVjmYR7dlp1d5+jSgr27Y2k
         IP8LJP14InI8S2BNmhXJuDhOkn65ISZQ1LFh/qA2VmoPoI5xZ+JpRMtQLqn1c4ZSa3id
         8zhvN9OEqtOjgpyoQ8qVGZ2KUNKBIA3OmHkvO/qldaJ+RaaZhHhunMmi1kkVIlmtoPdQ
         R9JDO5Svz6Qls9aewgqToJULuF/VcvNYoYOpR9VzgFxe0seaJPiFjwPsCcEsDMht9Rt6
         sihQ==
X-Gm-Message-State: AOAM531G/Ok1VCyey43ejLMQcndb8IhN4hPd9AaQ9ksZa1IiPZzBmOxm
        iIYQAeaWQA5sNg+xfrEBIrEYpzg2V1WFJkKBZ1hZPofZbtTCNtiPO/jIIuTOCXh2kUvELjkt2FD
        u6l8VzNtwTFTg3aJTbiIQdrABSIPrjbQl
X-Received: by 2002:a05:6638:2643:: with SMTP id n3mr25437148jat.104.1622557354739;
        Tue, 01 Jun 2021 07:22:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygxwpMCvXIUp/icYGLgdi1M+sFeVBPwGXl0cFRBG1vq/Vqr7GTg0GGr30SWEj/oWme0iRy5HuYaxp1fB+QkpE=
X-Received: by 2002:a05:6638:2643:: with SMTP id n3mr25437124jat.104.1622557354474;
 Tue, 01 Jun 2021 07:22:34 -0700 (PDT)
Received: from 868169051519 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 1 Jun 2021 14:22:34 +0000
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20210531124607.29602-1-simon.horman@corigine.com>
 <20210531124607.29602-9-simon.horman@corigine.com> <CALnP8Zb_MPukyNrFNWN9+--bQROQOqTV=K_cLngR_kmUMNJSDg@mail.gmail.com>
 <3bf36f32-58b7-fc24-bea8-ab4886888cb9@corigine.com>
MIME-Version: 1.0
In-Reply-To: <3bf36f32-58b7-fc24-bea8-ab4886888cb9@corigine.com>
Date:   Tue, 1 Jun 2021 14:22:34 +0000
Message-ID: <CALnP8Zb-EGBGOphrW-wvHbN-6=0eMD4u0AfdOb54ymN01V_+1A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 8/8] nfp: flower-ct: add tc merge functionality
To:     Louis Peens <louis.peens@corigine.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yinjun Zhang <yinjun.zhang@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 03:43:25PM +0200, Louis Peens wrote:
>
>
> On 2021/05/31 20:24, Marcelo Ricardo Leitner wrote:
> > On Mon, May 31, 2021 at 02:46:07PM +0200, Simon Horman wrote:
> >> +static int nfp_ct_do_tc_merge(struct nfp_fl_ct_zone_entry *zt,
> >> +			      struct nfp_fl_ct_flow_entry *ct_entry1,
> >> +			      struct nfp_fl_ct_flow_entry *ct_entry2)
> >> +{
> >> +	struct nfp_fl_ct_flow_entry *post_ct_entry, *pre_ct_entry;
> >> +	struct nfp_fl_ct_tc_merge *m_entry;
> >> +	unsigned long new_cookie[2];
> >> +	int err;
> >> +
> >> +	if (ct_entry1->type == CT_TYPE_PRE_CT) {
> >> +		pre_ct_entry = ct_entry1;
> >> +		post_ct_entry = ct_entry2;
> >> +	} else {
> >> +		post_ct_entry = ct_entry1;
> >> +		pre_ct_entry = ct_entry2;
> >> +	}
> >> +
> >> +	if (post_ct_entry->netdev != pre_ct_entry->netdev)
> >> +		return -EINVAL;
> >> +	if (post_ct_entry->chain_index != pre_ct_entry->chain_index)
> >> +		return -EINVAL;
> >
> > I would expect this to always fail with OVS/OVN offload, as it always
> > jump to a new chain after an action:ct call.
> Ah, I can see that this may look confusing, I will considering adding
> a short comment here for future me as well. The origin for the chain_index
> is different for pre_ct and post_ct. For pre_ct the chain_index is populated from
> the GOTO action, and for post_ct it is from the match. This checks that the
> chain in the action matches the chain in the filter of the next
> flow.
>
> The assignment happens in the nfp_fl_ct_handle_pre_ct and nfp_fl_ct_handle_post_ct
> functions of [PATCH net-next v2 5/8] nfp: flower-ct: add nfp_fl_ct_flow_entries

Got it. Thanks.

  Marcelo


Return-Path: <netdev+bounces-8074-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7D137229F8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:56:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2649281369
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F361F169;
	Mon,  5 Jun 2023 14:46:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D16E1EA9D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:46:11 +0000 (UTC)
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C73F10D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:46:08 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-77499bf8e8bso187400039f.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 07:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685976367; x=1688568367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ognRnxRIPFYGJpg3EONSI/9D/jIzsFVac4r9mTNLF8=;
        b=vydCafR5wehzorWmZICs60YOZ/rU55boNs1bORD2ydip1GRXwJE6Z82SFJtPCyJbQM
         thkrLBwC/GPvTUUVtmtpYzpPPcPwT2s3hTjbfw9KhEwCieVaWgJ/S7yJIU76Y6c7lMd+
         U+l1rxvTvivs6O5aj7QYh9AddpzyGq1C7iAfhylfEsuMqUcyrKNc4/aA5weMpM5AcYeq
         pKSn6zupxPLdkaXHQNfXkEmc79GK8SCpsQgbgD+WoJaz3IUoI1ZCT1+VTNyR8sM/XdRh
         9wNyvWCz7JAxXk50KglQjcOH+NnwjfFGg43FGYCbK2UgWIpvsZ3m3Z6AVdQSnBRNh65F
         4eRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685976367; x=1688568367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ognRnxRIPFYGJpg3EONSI/9D/jIzsFVac4r9mTNLF8=;
        b=UdCKPYQ/htqzRpcDcE0odOjY7folZrsoF4uVhjxNlZglbOzpWNM7wJkFgAz7wuOasQ
         utYkh4HBwLMPWfHcCM58ilQ57RT4jdfewuJSPVN4mTmrMfnXYdhfHJQjloIXXkWTZ2BW
         ZLtwnuTb7o1o2ypHOQDhZ7ubTLapT/eVj8RsoT/JrgHKB/TBtjJztHFZiEqOnR5LW6l9
         5xngecih44IWYtN1McvN6HTo1CDt08ZHfu1pXN3LU61jfZMlcj4KZJ0/0jZmv0IoZDFv
         sigb06A4X8I6EPyG3Bv1RB++L/ej+8AgYsz0L+4rTdI+gY0T4VqPKmRaFm1AVtKm+plc
         h9Jw==
X-Gm-Message-State: AC+VfDwsEVvT7RSevQzD8+2PHI3GJsgTz3Khs4jzlQMYfSjqmiG1g6wJ
	MtmJN3D3cc9z8164TEFJuhyuFTC0En6gH1+p/z522A==
X-Google-Smtp-Source: ACHHUZ4hKrtV3MnEJPR/hHmBsj/u8tdCH0kQgA2h1p1PTJKA4Xy+KQwZLIHTuQVghN8MZz6HGZjDnQpI7onQ81zYK2k=
X-Received: by 2002:a6b:917:0:b0:76c:85da:e25f with SMTP id
 t23-20020a6b0917000000b0076c85dae25fmr33594ioi.12.1685976367833; Mon, 05 Jun
 2023 07:46:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230124170510.316970-1-jhs@mojatatu.com> <20230124170510.316970-13-jhs@mojatatu.com>
 <ZH23SwFoyHuQ4AIx@corigine.com>
In-Reply-To: <ZH23SwFoyHuQ4AIx@corigine.com>
From: Jamal Hadi Salim <hadi@mojatatu.com>
Date: Mon, 5 Jun 2023 10:45:57 -0400
Message-ID: <CAAFAkD-prZmSd_FWxiphUnpC7i-s88E4QVniANT5ZpG4HC1a2A@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 13/20] p4tc: add metadata create, update,
 delete, get, flush and dump
To: Simon Horman <simon.horman@corigine.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org, kernel@mojatatu.com, 
	deb.chatterjee@intel.com, anjali.singhai@intel.com, namrata.limaye@intel.com, 
	khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io, jiri@resnulli.us, 
	xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, vladbu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 6:22=E2=80=AFAM Simon Horman <simon.horman@corigine.=
com> wrote:
>
> On Tue, Jan 24, 2023 at 12:05:03PM -0500, Jamal Hadi Salim wrote:
>
> ...
>
> Hi Victor, Jamal and Pedro,
>
> some minor feedback from my side.
>
> > +struct p4tc_metadata *tcf_meta_create(struct nlmsghdr *n, struct nlatt=
r *nla,
> > +                                   u32 m_id, struct p4tc_pipeline *pip=
eline,
> > +                                   struct netlink_ext_ack *extack)
>
> A gcc-12 build with W=3D1 suggests that this function could be static.
>

Ok, makes sense.
Looking at our CICD we run gcc-11. Would it be beneficial to switch to 12?

> ...
>
> > +static int _tcf_meta_fill_nlmsg(struct sk_buff *skb,
> > +                             const struct p4tc_metadata *meta)
> > +{
> > +     unsigned char *b =3D nlmsg_get_pos(skb);
> > +     struct p4tc_meta_size_params sz_params;
> > +     struct nlattr *nest;
> > +
> > +     if (nla_put_u32(skb, P4TC_PATH, meta->m_id))
> > +             goto out_nlmsg_trim;
> > +
> > +     nest =3D nla_nest_start(skb, P4TC_PARAMS);
> > +     if (!nest)
> > +             goto out_nlmsg_trim;
> > +
> > +     sz_params.datatype =3D meta->m_datatype;
> > +     sz_params.startbit =3D meta->m_startbit;
> > +     sz_params.endbit =3D meta->m_endbit;
>
> There may be a hole at the end of sz_params, which is uninitialised,
> yet fed into nl_put below.
>

Two ways to resolve that:
We could do:
struct p4tc_meta_size_params sz_params =3D {}
or add explicit PADx fields at the end of that struct.
Thoughts?

cheers,
jamal

> > +
> > +     if (nla_put_string(skb, P4TC_META_NAME, meta->common.name))
> > +             goto out_nlmsg_trim;
> > +     if (nla_put(skb, P4TC_META_SIZE, sizeof(sz_params), &sz_params))
> > +             goto out_nlmsg_trim;
> > +
> > +     nla_nest_end(skb, nest);
> > +
> > +     return skb->len;
> > +
> > +out_nlmsg_trim:
> > +     nlmsg_trim(skb, b);
> > +     return -1;
> > +}
>
> ...


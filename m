Return-Path: <netdev+bounces-8043-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 407C37228C4
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:26:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDE52281234
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68A231E50C;
	Mon,  5 Jun 2023 14:26:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4B61548E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:26:47 +0000 (UTC)
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7558C9C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:26:46 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-33d0b7114a9so23834535ab.2
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 07:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685975206; x=1688567206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5dFJNAcnEQzoqCk0zIwIbjw/b0XTfaw+UcgrcrPis+M=;
        b=mGS4yJqW0R0cjlokTq3PNgbrajUqKIGEBKGZCfBcUT5NFpjek4JLHhTDndW99DSJ7m
         3gaBcnX8Kn01XkttPDvU5XHkuSulw+W4YQvGglBQQOZc0iIwQoVIwSpkdZzhWmIRQUx8
         ixjoxfT5kwZ5ZVSrxayTjlEtHf7AXi6S3Hdj9PUW59h8QbqcCsA8IguKEc9FM+QPjYjF
         2RKfTRsxLkMxkdANFUokX+ravELDHka5qdLXwS3Rs6cnCZ6Hqt8w9YBNjeM2xHqFKq0S
         IuW0HazccgCoEWgTa6Wb+oRVOAr1oHhE1TIcSlza0SZ8MOeIgqj9Y3HdsnHlEx0yBq89
         5asw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685975206; x=1688567206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5dFJNAcnEQzoqCk0zIwIbjw/b0XTfaw+UcgrcrPis+M=;
        b=PdRI8ixI6h07I1WuucNLQObMqZov6Eh94MzkylbTn9Pku4Pk/Z0f3FsnYzDSCuwJsO
         se+NmQ/BU5kPL50XPXxkTA0DuG+dtM7Ya/rb4RulQ609J4CrBE99gZdqcWVfDHFolhyi
         yXBCtLwriMA+9rMQlhMvIfLHUMOxusCFURpEQHpDEHZjeK3I2nYGL0t/0/Z8DcHqGT+Q
         z/4HLGBRqWFlF9Rzm6TTYd8MI3V0EcQlR1Jp8yvyqOuTHV7aT7aql2Wmj5GRenbV+gST
         4+n4YshRZ9Bd5r4IQykgI/gapapgfxZyg7Blf6GmnNC+xt/qZvco/CI+VS8kkwKkbgxF
         fTpw==
X-Gm-Message-State: AC+VfDwHDZbn4oOh42EsJgGCd+IKlYJS34GN9gX4O10O7ykvaDMuyI67
	VYn2bJEMwIbBkwsv4WdKRVijsXhyJUseByHJDH4fDw==
X-Google-Smtp-Source: ACHHUZ69wBIl4P/xOfSMxQHl7GOCpEVbta5nUUjp14EjTPQX44QGhV+DK/+cnDqJw4doJKfCkn6vnYgiO1+VqE65VHk=
X-Received: by 2002:a92:6e04:0:b0:338:f770:ccc3 with SMTP id
 j4-20020a926e04000000b00338f770ccc3mr15640ilc.21.1685975205810; Mon, 05 Jun
 2023 07:26:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-9-jhs@mojatatu.com>
 <ZH20IH+yHMk5kAcb@corigine.com>
In-Reply-To: <ZH20IH+yHMk5kAcb@corigine.com>
From: Jamal Hadi Salim <hadi@mojatatu.com>
Date: Mon, 5 Jun 2023 10:26:35 -0400
Message-ID: <CAAFAkD80rfz2QcvOyfLVFRF9QSDm5UzOA7LmY9A7chT_0B8SjA@mail.gmail.com>
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 09/28] p4tc: add P4
 data types
To: Simon Horman <simon.horman@corigine.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org, deb.chatterjee@intel.com, 
	tom@sipanda.io, p4tc-discussions@netdevconf.info, Mahesh.Shirshyad@amd.com, 
	Vipin.Jain@amd.com, tomasz.osinski@intel.com, xiyou.wangcong@gmail.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 6:08=E2=80=AFAM Simon Horman via p4tc-discussions
<p4tc-discussions@netdevconf.info> wrote:
>
> On Wed, May 17, 2023 at 07:02:13AM -0400, Jamal Hadi Salim wrote:
> > Introduce abstraction that represents P4 data types.
> > This also introduces the Kconfig and Makefile which later patches use.
> > Types could be little, host or big endian definitions. The abstraction =
also
> > supports defining:
> >
> > a) bitstrings using annotations in control that look like "bitX" where =
X
> >    is the number of bits defined in a type
> >
> > b) bitslices such that one can define in control bit8[0-3] and
> >    bit16[0-9]. A 4-bit slice from bits 0-3 and a 10-bit slice from bits
> >    0-9 respectively.
> >
> > Each type has a bitsize, a name (for debugging purposes), an ID and
> > methods/ops. The P4 types will be used by metadata, headers, dynamic
> > actions and other part of P4TC.
> >
> > Each type has four ops:
> >
> > - validate_p4t: Which validates if a given value of a specific type
> >   meets valid boundary conditions.
> >
> > - create_bitops: Which, given a bitsize, bitstart and bitend allocates =
and
> >   returns a mask and a shift value. For example, if we have type bit8[3=
-3]
> >   meaning bitstart =3D 3 and bitend =3D 3, we'll create a mask which wo=
uld only
> >   give us the fourth bit of a bit8 value, that is, 0x08. Since we are
> >   interested in the fourth bit, the bit shift value will be 3.
> >
> > - host_read : Which reads the value of a given type and transforms it t=
o
> >   host order
> >
> > - host_write : Which writes a provided host order value and transforms =
it
> >   to the type's native order
> >
> > Co-developed-by: Victor Nogueira <victor@mojatatu.com>
> > Signed-off-by: Victor Nogueira <victor@mojatatu.com>
> > Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
> > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
>
> Hi Victor, Pedro and Jamal,
>
> some minor feedback from my side.
>
> > diff --git a/net/sched/p4tc/p4tc_types.c b/net/sched/p4tc/p4tc_types.c
>
> ...
>
> > +static struct p4tc_type *p4type_find_byname(const char *name)
> > +{
> > +     struct p4tc_type *type;
> > +     unsigned long tmp, typeid;
>
> As per my comment on another patch in this series,
> please use reverse xmas tree - longest line to shortest -
> for local variable declarations in networking code.
>
> The following tool can help:
> https://github.com/ecree-solarflare/xmastree

Ok, we will add this tool to our CICD.

> > +
> > +     idr_for_each_entry_ul(&p4tc_types_idr, type, tmp, typeid) {
> > +             if (!strncmp(type->name, name, P4T_MAX_STR_SZ))
> > +                     return type;
> > +     }
> > +
> > +     return NULL;
> > +}
>
> ...
>
> > +static int p4t_be32_validate(struct p4tc_type *container, void *value,
> > +                          u16 bitstart, u16 bitend,
> > +                          struct netlink_ext_ack *extack)
> > +{
> > +     size_t container_maxsz =3D U32_MAX;
> > +     __u32 *val_u32 =3D value;
> > +     __be32 val =3D 0;
> > +     size_t maxval;
> > +     int ret;
> > +
> > +     ret =3D p4t_validate_bitpos(bitstart, bitend, 31, 31, extack);
> > +     if (ret < 0)
> > +             return ret;
> > +
> > +     if (value)
> > +             val =3D (__be32)(be32_to_cpu(*val_u32));
>
> From a type annotation point of view, a value can be either CPU byte orde=
r
> or big endian. It can't be both. What was the byte order of val_u32?  Wha=
t is
> the desired byte order of val?
>
> Sparse, invoked using make C=3D1, flags this and
> sever other issues with endineness handling.

The cast is wrong, thanks for the catch Simon - we'll fix in the next
version. We do run sparse - we'll double check how we missed this one.

cheers,
jamal

> > +
> > +     maxval =3D GENMASK(bitend, 0);
> > +     if (val && (val > container_maxsz || val > maxval)) {
> > +             NL_SET_ERR_MSG_MOD(extack, "BE32 value out of range");
> > +             return -EINVAL;
> > +     }
> > +
> > +     return 0;
> > +}
>
> ...
> _______________________________________________
> p4tc-discussions mailing list -- p4tc-discussions@netdevconf.info
> To unsubscribe send an email to p4tc-discussions-leave@netdevconf.info


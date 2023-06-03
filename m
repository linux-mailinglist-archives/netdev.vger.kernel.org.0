Return-Path: <netdev+bounces-7663-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA4CE72104B
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 15:55:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DC1F281A2A
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 13:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B4AC8E3;
	Sat,  3 Jun 2023 13:55:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6822904
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 13:55:03 +0000 (UTC)
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB2F9F
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:55:01 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-565ee3d14c2so34178827b3.2
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 06:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685800500; x=1688392500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sqUICyPL9DIv9E1yCl5oIBdmT5SG15e4VjkdP2tdYZ4=;
        b=t/U09IBdfEY4iG+2n6Hz/HC20ds3s5AVqbO8c0DUctlsO52/ixGde+NFAJ+e6bJmki
         fSeVdoEQrqoI60jJScK2ovxM33nAUPZ5XZygrjsFiF+fst5LUegZFkp4qJZo3Ped9psZ
         veEuW9o6Yg/BRg0GluTvMOCKKphTjWnbBfMoo+ljmrf56o5YRTNuoCkkvFgJDD4abkVr
         zIiaDHnxljPnt79xjT7RcKrclj+paWp7VsQcm6drGF6iIBxosnvm9Ug1KPYa+yziRKfG
         evE3DdMZocld2rRAN0h7PW48cXthb1T7JypHegZfJcyziwh1M4s8uk1jxWftzwIhGJgX
         mXLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685800500; x=1688392500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sqUICyPL9DIv9E1yCl5oIBdmT5SG15e4VjkdP2tdYZ4=;
        b=Vo7uow+tABMTccf5sZGjOoBm/XP+U5rdE9oMJw0FNJCerTLxQ5RsWVPvyvDNItRDxE
         ALy+hFvhnGF867/6hy8tl0AusGmtV/Mwm1RUVeJ9SwVRyyBco6ue8TrAFwedxcIqVtA3
         kJbPOz2WIqZFH84Lm3cUA668bjwhLUhu25TMeNpqeZ644DP0qJwIBCTF41QsCymKGUBH
         IIPMR7tHooeMJcM1CC3nHZcjE3dGA7fXh/czY0EFeVmi4yDF4urlXassL9G3oy2X/tPZ
         OmSXuwM9ba2SHAU5nfKZlb3d1uScXkHcGcwJaf7ao18gABI7icsEnyTye5lKJ2DM86dC
         V6Hw==
X-Gm-Message-State: AC+VfDzg10slfJ6AAq8ZcYptK4SaMZnWTRclQjosI72t7nwHOaw9XBjm
	k5dRGs0Qy+03Ru1LFgqHW9BO/Hb7SFhGvRQQeiTzXA==
X-Google-Smtp-Source: ACHHUZ5hrMzxQEqcK0MNTgXVkyOkQ84db/ZbPmbPBZTSzhlzB4Zb8rQk7MUAgX7cVdPsWVXi0aTsnoXOC3RF9Sk4Naw=
X-Received: by 2002:a0d:e0c1:0:b0:565:1058:abbd with SMTP id
 j184-20020a0de0c1000000b005651058abbdmr3642727ywe.35.1685800500510; Sat, 03
 Jun 2023 06:55:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-9-jhs@mojatatu.com>
 <CALnP8ZZk8-ZowUcvD1UZTBsVjxth7xaTY1CwvJUYj8XJEKhkeg@mail.gmail.com>
In-Reply-To: <CALnP8ZZk8-ZowUcvD1UZTBsVjxth7xaTY1CwvJUYj8XJEKhkeg@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 3 Jun 2023 09:54:48 -0400
Message-ID: <CAM0EoMnWCTtpVjtgErubwGNuimgc5wP9MY2G7S2dPTr5rXvKsw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 09/28] p4tc: add P4 data types
To: Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com, anjali.singhai@intel.com, 
	namrata.limaye@intel.com, tom@sipanda.io, p4tc-discussions@netdevconf.info, 
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com, tomasz.osinski@intel.com, 
	jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, vladbu@nvidia.com, 
	simon.horman@corigine.com, khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 4:30=E2=80=AFPM Marcelo Ricardo Leitner
<mleitner@redhat.com> wrote:
>
> On Wed, May 17, 2023 at 07:02:13AM -0400, Jamal Hadi Salim wrote:
> > +bool p4tc_type_unsigned(int typeid)
>
> Nit, maybe name it p4tc_is_type_unsigned() instead.
>

Yeah, that sounds better... we'll make the change.

> > +{
> > +     switch (typeid) {
> > +     case P4T_U8:
> > +     case P4T_U16:
> > +     case P4T_U32:
> > +     case P4T_U64:
> > +     case P4T_U128:
> > +     case P4T_BOOL:
> > +             return true;
> > +     default:
> > +             return false;
> > +     }
> > +}
> > +
> > +int p4t_copy(struct p4tc_type_mask_shift *dst_mask_shift,
> > +          struct p4tc_type *dst_t, void *dstv,
> > +          struct p4tc_type_mask_shift *src_mask_shift,
> > +          struct p4tc_type *src_t, void *srcv)
> > +{
> > +     u64 readval[BITS_TO_U64(P4TC_MAX_KEYSZ)] =3D {0};
> > +     const struct p4tc_type_ops *srco, *dsto;
> > +
> > +     dsto =3D dst_t->ops;
> > +     srco =3D src_t->ops;
> > +
> > +     __p4tc_type_host_read(srco, src_t, src_mask_shift, srcv,
> > +                           &readval);
> > +     __p4tc_type_host_write(dsto, dst_t, dst_mask_shift, &readval,
> > +                            dstv);
> > +
> > +     return 0;
>
> The return value on these (write) functions seems to be inconsistent.
> All the write functions are returning 0. Then, __p4tc_type_host_write
> itself propagates the return value, but then here it doesn't.


Yeah, mostly these should not "fail" (famous last words) due to
memcpy. We started by looking at the return of memcpy - which returns
the pointer to dest but is known to fail under some circumstances eg
buffers overlap due to some bug on the caller side; so to be safe at
the time was to do the check and return a failure when detected. But
then we argued amongst ourselves and decided not to check. So what you
are seeing is a result of that and there is some leftover you caught
in your inspection. We could either go back and add the check or
totally remove it to make it return void. Thoughts?

> > +}
> > +
> > +int p4t_cmp(struct p4tc_type_mask_shift *dst_mask_shift,
> > +         struct p4tc_type *dst_t, void *dstv,
> > +         struct p4tc_type_mask_shift *src_mask_shift,
> > +         struct p4tc_type *src_t, void *srcv)
> > +{
> > +     u64 a[BITS_TO_U64(P4TC_MAX_KEYSZ)] =3D {0};
> > +     u64 b[BITS_TO_U64(P4TC_MAX_KEYSZ)] =3D {0};
> > +     const struct p4tc_type_ops *srco, *dsto;
> > +
> > +     dsto =3D dst_t->ops;
> > +     srco =3D src_t->ops;
> > +
> > +     __p4tc_type_host_read(dsto, dst_t, dst_mask_shift, dstv, a);
> > +     __p4tc_type_host_read(srco, src_t, src_mask_shift, srcv, b);
> > +
> > +     return memcmp(a, b, sizeof(a));
> > +}
> > +
> > +void p4t_release(struct p4tc_type_mask_shift *mask_shift)
> > +{
> > +     kfree(mask_shift->mask);
> > +     kfree(mask_shift);
> > +}
> > +
> > +static int p4t_validate_bitpos(u16 bitstart, u16 bitend, u16 maxbitsta=
rt,
> > +                            u16 maxbitend, struct netlink_ext_ack *ext=
ack)
> > +{
> > +     if (bitstart > maxbitstart) {
> > +             NL_SET_ERR_MSG_MOD(extack, "bitstart too high");
> > +             return -EINVAL;
> > +     }
> > +     if (bitend > maxbitend) {
> > +             NL_SET_ERR_MSG_MOD(extack, "bitend too high");
> > +             return -EINVAL;
> > +     }
>
> Do we want a condition for
>  +      if (bitstart > bitend) {
>  +              NL_SET_ERR_MSG_MOD(extack, "bitstart after bitend");
>  +              return -EINVAL;
>  +      }
> ?


We'll audit the code again - but we normally check for that condition
at the caller level (eg check patch 17, validate_metadata_operand())
It may be worth doing it here instead of at the caller.

> > +
> > +     return 0;
> > +}
> > +
> > +//XXX: Latter immedv will be 64 bits
> > +static int p4t_u32_validate(struct p4tc_type *container, void *value,
> > +                         u16 bitstart, u16 bitend,
> > +                         struct netlink_ext_ack *extack)
> > +{
> > +     u32 container_maxsz =3D U32_MAX;
> > +     u32 *val =3D value;
> > +     size_t maxval;
> > +     int ret;
> > +
> > +     ret =3D p4t_validate_bitpos(bitstart, bitend, 31, 31, extack);
> > +     if (ret < 0)
> > +             return ret;
> > +
> > +     maxval =3D GENMASK(bitend, 0);
> > +     if (val && (*val > container_maxsz || *val > maxval)) {
> > +             NL_SET_ERR_MSG_MOD(extack, "U32 value out of range");
> > +             return -EINVAL;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static struct p4tc_type_mask_shift *
> > +p4t_u32_bitops(u16 bitsiz, u16 bitstart, u16 bitend,
> > +            struct netlink_ext_ack *extack)
> > +{
> > +     u32 mask =3D GENMASK(bitend, bitstart);
> > +     struct p4tc_type_mask_shift *mask_shift;
> > +     u32 *cmask;
> > +
> > +     mask_shift =3D kzalloc(sizeof(*mask_shift), GFP_KERNEL);
> > +     if (!mask_shift)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     cmask =3D kzalloc(sizeof(u32), GFP_KERNEL);
> > +     if (!cmask) {
> > +             kfree(mask_shift);
> > +             return ERR_PTR(-ENOMEM);
> > +     }
> > +
> > +     *cmask =3D mask;
> > +
> > +     mask_shift->mask =3D cmask;
> > +     mask_shift->shift =3D bitstart;
>
> AFAICT, mask_shift->mask is never shared. So maybe consider
> embedding mask onto mask_shift itself, to avoid the double allocation.
> I mean, something like
> +       mask_shift =3D kzalloc(sizeof(*mask_shift)+sizeof(u32), GFP_KERNE=
L);
> +       cmask =3D mask_shift+1;
>
> This may also help with cache miss later on.

It's a lot of mechanical work for us to do the conversion but it's
valuable if we can avoid the cache miss. We'll look into it - it may
not look exactly as what you have suggested but given we know exact
size so we can do some optimal things.

cheers,
jamal

> > +
> > +     return mask_shift;
> > +}
>


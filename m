Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07DE1EC1C4
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 20:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgFBS1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 14:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgFBS1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 14:27:17 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0A7C08C5C0;
        Tue,  2 Jun 2020 11:27:16 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id r125so6737542lff.13;
        Tue, 02 Jun 2020 11:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mw0A1EMjbP0QpDjC9h17qag8cRf1NervhA9yGpFDSfk=;
        b=nOTsOaAdN5kCuMt+z/tcJmqT+mvf62yBJZIyJqThbdcBFBCTnhM0ifZgJghCvCsyRS
         f3hSMxZ9QfstXL6Lnf9H9Pj2vIdrFYit69KlxRrz/0+On0UALO04lQ/ds8EYfVF/bWr7
         Yr3iBz3uonxYIvDYZhy3JJeOgRC+62tTn/qzkDLC/24ARpJQrbUK2CQcFG+Y+x8jDZ7P
         pKxBlA8jBjgJU+Sq7MFEootaAog4t8kLTrECuz78Ntg3k2xFNJcjwlbUOFZn5wBOX7oU
         PmGxNV6SOa8vBi6rogt7i1rYjKlDqRPtx0spuG9Dv3So9/EJ5cvbXzbnu9abwHgjaO6T
         PwbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mw0A1EMjbP0QpDjC9h17qag8cRf1NervhA9yGpFDSfk=;
        b=G8bnu+AsSFJb++siEQl/eZ94YZfP88vcFkl391lRCpd39vLOOZdDZ1plJz9BcushLu
         j563QY+5aM4CRRBBwkooiNBZkJXQzTziVXRgwE9Xampjvw9j+yayDgXSM5STmVRCQOWN
         VSJVD7g5FtIeL2IXOPtQbZneEnM2PqpHRzjsMjssV2Ehav/5VN6BlkEXmrAWbzjz0NX3
         Ae0+XF+kxOC5FzNvW0eHYHK3ZW9kqEveyQbwzwyEwvOuxhqJsOWCjX2rhaNMqsmOTiv0
         vj/ftlXH8vA/fbss1yafvA3xsPWgvfx6L2ggR7tN5JPUBfUbsSWD2Ty6CJdyu4csy/R+
         AUqw==
X-Gm-Message-State: AOAM533bLQOF9AwfMMAUfl+HYyJJzYVpJoRLyM49QRNez6JFdcmmotg1
        o6z6Mx+SqLvIQN3FXBmyQhCwt4ufI35usMCBom8=
X-Google-Smtp-Source: ABdhPJyGEMNlLMbll5Hl1HP0/QWQeqLPmIldvvkylcKKjeRsK2hitNB9GyHrXBNoc4WCLmvUkiHlpxcCIdVENK2LxgQ=
X-Received: by 2002:a19:103:: with SMTP id 3mr337429lfb.196.1591122435033;
 Tue, 02 Jun 2020 11:27:15 -0700 (PDT)
MIME-Version: 1.0
References: <159076794319.1387573.8722376887638960093.stgit@firesoul>
 <159076798566.1387573.8417040652693679408.stgit@firesoul> <20200601213012.vgt7oqplfbzeddzm@ast-mbp.dhcp.thefacebook.com>
 <20200602090005.5a6eb50c@carbon>
In-Reply-To: <20200602090005.5a6eb50c@carbon>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 2 Jun 2020 11:27:03 -0700
Message-ID: <CAADnVQJDj_5i=g0S1UhxP1EUKwNUx1KuQ=V7y089+oy8rdnZ=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next RFC 2/3] bpf: devmap dynamic map-value storage
 area based on BTF
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 12:00 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Mon, 1 Jun 2020 14:30:12 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > On Fri, May 29, 2020 at 05:59:45PM +0200, Jesper Dangaard Brouer wrote:
> > > +
> > > +/* Expected BTF layout that match struct bpf_devmap_val */
> > > +static const struct expect layout[] = {
> > > +   {BTF_KIND_INT,          true,    0,      4,     "ifindex"},
> > > +   {BTF_KIND_UNION,        false,  32,      4,     "bpf_prog"},
> > > +   {BTF_KIND_STRUCT,       false,  -1,     -1,     "storage"}
> > > +};
> > > +
> > > +static int dev_map_check_btf(const struct bpf_map *map,
> > > +                        const struct btf *btf,
> > > +                        const struct btf_type *key_type,
> > > +                        const struct btf_type *value_type)
> > > +{
> > > +   struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
> > > +   u32 found_members_cnt = 0;
> > > +   u32 int_data;
> > > +   int off;
> > > +   u32 i;
> > > +
> > > +   /* Validate KEY type and size */
> > > +   if (BTF_INFO_KIND(key_type->info) != BTF_KIND_INT)
> > > +           return -EOPNOTSUPP;
> > > +
> > > +   int_data = *(u32 *)(key_type + 1);
> > > +   if (BTF_INT_BITS(int_data) != 32 || BTF_INT_OFFSET(int_data) != 0)
> > > +           return -EOPNOTSUPP;
> > > +
> > > +   /* Validate VALUE have layout that match/map-to struct bpf_devmap_val
> > > +    * - With a flexible size of member 'storage'.
> > > +    */
> > > +
> > > +   if (BTF_INFO_KIND(value_type->info) != BTF_KIND_STRUCT)
> > > +           return -EOPNOTSUPP;
> > > +
> > > +   /* Struct/union members in BTF must not exceed (max) expected members */
> > > +   if (btf_type_vlen(value_type) > ARRAY_SIZE(layout))
> > > +                   return -E2BIG;
> > > +
> > > +   for (i = 0; i < ARRAY_SIZE(layout); i++) {
> > > +           off = btf_find_expect_layout_offset(btf, value_type, &layout[i]);
> > > +
> > > +           if (off < 0 && layout[i].mandatory)
> > > +                   return -EUCLEAN;
> > > +
> > > +           if (off >= 0)
> > > +                   found_members_cnt++;
> > > +
> > > +           /* Transfer layout config to map */
> > > +           switch (i) {
> > > +           case 0:
> > > +                   dtab->cfg.btf_offset.ifindex = off;
> > > +                   break;
> > > +           case 1:
> > > +                   dtab->cfg.btf_offset.bpf_prog = off;
> > > +                   break;
> > > +           default:
> > > +                   break;
> > > +           }
> > > +   }
> > > +
> > > +   /* Detect if BTF/vlen have members that were not found */
> > > +   if (btf_type_vlen(value_type) > found_members_cnt)
> > > +           return -E2BIG;
> > > +
> > > +   return 0;
> > > +}
> >
> > This layout validation looks really weird to me.
> > That layout[] array sort of complements BTF to describe the data,
> > but double describe of the layout feels like hack.
>
> This is the kind of feedback I'm looking for.  I want to make the
> map-value more dynamic.  It seems so old school to keep extending the
> map-value with a size and fixed binary layout, when we have BTF
> available.  I'm open to input on how to better verify/parse/desc the
> expected BTF layout for kernel-code side.
>
> The patch demonstrates that this is possible, I'm open for changes.
> E.g. devmap is now extended with a bpf_prog, but most end-users will
> not be using this feature. Today they can use value_size=4 to avoid
> using this field. When we extend map-value again, then end-users are
> force into providing 'bpf_prog.fd' if they want to use the newer
> options.  In this patch end-users don't need to provide 'bpf_prog' if
> they don't use it. Via BTF we can see this struct member can be skipped.

I think 'struct bpf_devmap_val' should be in uapi/bpf.h.
That's what it is and it will be extended with new fields at the end
just like all other structs in uapi/bpf.h
I don't think BTF can become a substitute for uapi
where uapi struct has to have all fields defined and backwards supported
by the kernel.
BTF is for flexible structs where fields may disappear.
BTF is there to define a meaning of a binary blob.
'struct bpf_devmap_val' is not such thing. It's very much known with
fixed fields and fixed meaning.

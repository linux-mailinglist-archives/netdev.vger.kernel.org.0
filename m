Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41C81ED41F
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 18:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgFCQVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 12:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgFCQVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 12:21:02 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1BCC08C5C0;
        Wed,  3 Jun 2020 09:21:02 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id s23so600693pfh.7;
        Wed, 03 Jun 2020 09:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Aiq2AGjBzRrwyEbJHoXqJ34yChLkQYcZ8n+OPCSBQHU=;
        b=rOP1ZUsBe4d1xfN9oF2de7yzQpf7vhEb46NDxLJm+pWWJTJfn7H29WojAZiBp0/AMl
         0n82VsZGWWTBiMH+LrktAAdz3wFwVY6lLOAwJPl1jgCLF0wjoFfpLA6EQGBMHjbZLgCd
         +F+kmyj7o/QNZScOAQL4NcB8kCCNvqIOzXjC7W0vFPfhqGNAQoH18qfhFLyD1w+qV+a6
         olH++v5S6QyB0AwgJPk+Jp+TmliyBQs1k5h7X0jJ/uTX2kbXf6gM7H0mZUDoV98+vfVw
         9H/dlZylb5LFzLdlD9vLUdSar0loSaqgdxOkgS9VA2g437Rh21vtuafGdZFvXGyvKX/z
         yG2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Aiq2AGjBzRrwyEbJHoXqJ34yChLkQYcZ8n+OPCSBQHU=;
        b=bW1rsnZnfoKtf5HKlDzuxfcrjjJ+EWOKZmc+ALZhFNYWguMJNFJZ7YC1tuibDJEMwT
         tvB06+Ayb2vIJO5qA8se9RSMQiwAp9uMcpvy9spzBF8uhCHNRDLNGxKE2n4WuzRaobqc
         7YX7A3p3TnRLyqowmLcp2dL0jJeA9sU1SlPFKhB5FzHreHWx7vtGGNADzNuz/gH/6nWU
         LWiptlr67j+7g40L4bFdY7D08u/o7dQf1fkO0w6FD26L4QAklMVdVZvgwedfe12Py26c
         fCOEfimoRuboy8ZA/xXp70oOIh7tgCWcQAEATxz+xuCFoWoe4iTGvDzwniTy5bcxune+
         O/ew==
X-Gm-Message-State: AOAM532n4eWF46xJ+tJhjRqNyn3b2VFpXp9w0aC+4/EHe9jIIV+xmFsE
        IhUGiiQdYOJyakyhrFQ+Lns=
X-Google-Smtp-Source: ABdhPJz4ULZxfTmq9fifUsmhTzFNRiLoNj/pURRs0c+taQ12zKbOGrS3ANcZo3OM+6rVaeXcXpTCUA==
X-Received: by 2002:a63:3e0e:: with SMTP id l14mr155532pga.187.1591201261883;
        Wed, 03 Jun 2020 09:21:01 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:514a])
        by smtp.gmail.com with ESMTPSA id u8sm2256657pfh.193.2020.06.03.09.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 09:21:00 -0700 (PDT)
Date:   Wed, 3 Jun 2020 09:20:58 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH bpf-next RFC 2/3] bpf: devmap dynamic map-value storage
 area based on BTF
Message-ID: <20200603162058.ow3ac5j5qtb3k567@ast-mbp.dhcp.thefacebook.com>
References: <159076794319.1387573.8722376887638960093.stgit@firesoul>
 <159076798566.1387573.8417040652693679408.stgit@firesoul>
 <20200601213012.vgt7oqplfbzeddzm@ast-mbp.dhcp.thefacebook.com>
 <20200602090005.5a6eb50c@carbon>
 <CAADnVQJDj_5i=g0S1UhxP1EUKwNUx1KuQ=V7y089+oy8rdnZ=g@mail.gmail.com>
 <20200603111158.2cfd99e5@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603111158.2cfd99e5@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 11:11:58AM +0200, Jesper Dangaard Brouer wrote:
> On Tue, 2 Jun 2020 11:27:03 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > On Tue, Jun 2, 2020 at 12:00 AM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote:
> > >
> > > On Mon, 1 Jun 2020 14:30:12 -0700
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > >  
> > > > On Fri, May 29, 2020 at 05:59:45PM +0200, Jesper Dangaard Brouer wrote:  
> > > > > +
> > > > > +/* Expected BTF layout that match struct bpf_devmap_val */
> > > > > +static const struct expect layout[] = {
> > > > > +   {BTF_KIND_INT,          true,    0,      4,     "ifindex"},
> > > > > +   {BTF_KIND_UNION,        false,  32,      4,     "bpf_prog"},
> > > > > +   {BTF_KIND_STRUCT,       false,  -1,     -1,     "storage"}
> > > > > +};
> > > > > +
> > > > > +static int dev_map_check_btf(const struct bpf_map *map,
> > > > > +                        const struct btf *btf,
> > > > > +                        const struct btf_type *key_type,
> > > > > +                        const struct btf_type *value_type)
> > > > > +{
> > > > > +   struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
> > > > > +   u32 found_members_cnt = 0;
> > > > > +   u32 int_data;
> > > > > +   int off;
> > > > > +   u32 i;
> > > > > +
> > > > > +   /* Validate KEY type and size */
> > > > > +   if (BTF_INFO_KIND(key_type->info) != BTF_KIND_INT)
> > > > > +           return -EOPNOTSUPP;
> > > > > +
> > > > > +   int_data = *(u32 *)(key_type + 1);
> > > > > +   if (BTF_INT_BITS(int_data) != 32 || BTF_INT_OFFSET(int_data) != 0)
> > > > > +           return -EOPNOTSUPP;
> > > > > +
> > > > > +   /* Validate VALUE have layout that match/map-to struct bpf_devmap_val
> > > > > +    * - With a flexible size of member 'storage'.
> > > > > +    */
> > > > > +
> > > > > +   if (BTF_INFO_KIND(value_type->info) != BTF_KIND_STRUCT)
> > > > > +           return -EOPNOTSUPP;
> > > > > +
> > > > > +   /* Struct/union members in BTF must not exceed (max) expected members */
> > > > > +   if (btf_type_vlen(value_type) > ARRAY_SIZE(layout))
> > > > > +                   return -E2BIG;
> > > > > +
> > > > > +   for (i = 0; i < ARRAY_SIZE(layout); i++) {
> > > > > +           off = btf_find_expect_layout_offset(btf, value_type, &layout[i]);
> > > > > +
> > > > > +           if (off < 0 && layout[i].mandatory)
> > > > > +                   return -EUCLEAN;
> > > > > +
> > > > > +           if (off >= 0)
> > > > > +                   found_members_cnt++;
> > > > > +
> > > > > +           /* Transfer layout config to map */
> > > > > +           switch (i) {
> > > > > +           case 0:
> > > > > +                   dtab->cfg.btf_offset.ifindex = off;
> > > > > +                   break;
> > > > > +           case 1:
> > > > > +                   dtab->cfg.btf_offset.bpf_prog = off;
> > > > > +                   break;
> > > > > +           default:
> > > > > +                   break;
> > > > > +           }
> > > > > +   }
> > > > > +
> > > > > +   /* Detect if BTF/vlen have members that were not found */
> > > > > +   if (btf_type_vlen(value_type) > found_members_cnt)
> > > > > +           return -E2BIG;
> > > > > +
> > > > > +   return 0;
> > > > > +}  
> > > >
> > > > This layout validation looks really weird to me.
> > > > That layout[] array sort of complements BTF to describe the data,
> > > > but double describe of the layout feels like hack.  
> > >
> > > This is the kind of feedback I'm looking for.  I want to make the
> > > map-value more dynamic.  It seems so old school to keep extending the
> > > map-value with a size and fixed binary layout, when we have BTF
> > > available.  I'm open to input on how to better verify/parse/desc the
> > > expected BTF layout for kernel-code side.
> > >
> > > The patch demonstrates that this is possible, I'm open for changes.
> > > E.g. devmap is now extended with a bpf_prog, but most end-users will
> > > not be using this feature. Today they can use value_size=4 to avoid
> > > using this field. When we extend map-value again, then end-users are
> > > force into providing 'bpf_prog.fd' if they want to use the newer
> > > options.  In this patch end-users don't need to provide 'bpf_prog' if
> > > they don't use it. Via BTF we can see this struct member can be skipped.  
> > 
> > I think 'struct bpf_devmap_val' should be in uapi/bpf.h.
> 
> I disagree.
>
> > That's what it is and it will be extended with new fields at the end
> > just like all other structs in uapi/bpf.h
> 
> This only works when new fields added will be zero, meaning that
> default value of zero means the feature is not used.  In this specific
> case devmap adds a file-descriptor field, that have to be -1 for the
> feature to be unused.
> 
> Thus, when programs gets compiled with this new UAPI header, they will
> start to fail, because they try to map-insert file-descriptor zero.

No, because there is size that has to be specified.
There are plenty of other uapi structs that have non-zero values
in a newly added fields.

> 
> > I don't think BTF can become a substitute for uapi
> > where uapi struct has to have all fields defined and backwards supported
> > by the kernel.
> > BTF is for flexible structs where fields may disappear.
> 
> Then BTF is perfect for this, as e.g. I want to remove field/member
> 'ifindex' for the HASH-variant of devmap, and instead use the key as
> the ifindex.

nack to that.

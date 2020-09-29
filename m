Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C2727C17A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgI2Jmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbgI2Jmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 05:42:45 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA13C061755;
        Tue, 29 Sep 2020 02:42:43 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id o20so3948309pfp.11;
        Tue, 29 Sep 2020 02:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U0BKsu50ZV7I0+tQSJXxg4J3/Ui/TxQlAjMQ0bPbdeQ=;
        b=IUMde1DR9c+C04h+hKWnTUgCmHfuCnrQjQIrKtle+jp0Ul8EcRcgo9Ab+hvagJEAVr
         iGmobxuuhRxEKrlqB8swudr2c2pjba8xfChUmET+k7G7y2EOID7cVWjk47/M8lQnuB74
         +c17cuwcgMuA0EKXJ1E2rLlfP4FgScOo08Waf5kBjOEWbfbS57l10svbhEyiAuu5AENW
         UUEHnvjTSeT0idI73fN+SxxK+GtM+hk6rTlmvKM3zYtCeDfnqsi2vipVR6zehguDjQBk
         bSdTLdCCzJkCNCud31qzxyRQOY5e1Mm4NVIEuHHPV52lEPAaXDWSWObu0Mn15hEvcLll
         OnjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U0BKsu50ZV7I0+tQSJXxg4J3/Ui/TxQlAjMQ0bPbdeQ=;
        b=H2pAQMIOlCQVcZckXCOrvMqSRxXwIqmwL3hsXfxsQXLaIVo1fgbyCVy7b0MtGzECKD
         gpggtk7T5TKlRnzgYw8lhKOBxLgq7RzF4bl2kjhqAlAYRIxRZ5kRpx7BViDTgziJoeDt
         VM1OIsPvJnF0ZAlEp+NHTP2WpFxcV+lO07mhjEoWdJhK/nWNk696cFfkAMVZIXl1lV9j
         n3KxZm3QSQUjWd5lJlA8vE7/qNYzLsOe9H00atitAtk6GS8wiwCmlh+kz8qoVcApYrl5
         /9l/2qTtPM+HVPdUNXcVWJSFArJpVQnzuW9dhKykK2k8xw2sQBEMAdL0AYNNw8j5oMJV
         nh5w==
X-Gm-Message-State: AOAM533lRCWj9mHHJRxHPVevG9o3OBv2MNLv5/4ZcVtdfi3aI9mP0HQa
        0NPurK4O9ydE0vS+8NGCz6E=
X-Google-Smtp-Source: ABdhPJz/Yv/LvhkOKqY5hT6LRzuOQUDF/NXwSb8OJ3tT4MslHrknG8B3aCCoT5wBZkibpUUVykKKoQ==
X-Received: by 2002:a63:25c3:: with SMTP id l186mr2551098pgl.229.1601372563403;
        Tue, 29 Sep 2020 02:42:43 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id kk17sm3502186pjb.31.2020.09.29.02.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 02:42:42 -0700 (PDT)
Date:   Tue, 29 Sep 2020 17:42:32 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: export bpf_object__reuse_map() to
 libbpf api
Message-ID: <20200929094232.GG2531@dhcp-12-153.nay.redhat.com>
References: <20200929031845.751054-1-liuhangbin@gmail.com>
 <CAEf4BzYKtPgSxKqduax1mW1WfVXKuCEpbGKRFvXv7yNUmUm_=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYKtPgSxKqduax1mW1WfVXKuCEpbGKRFvXv7yNUmUm_=A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 08:30:42PM -0700, Andrii Nakryiko wrote:
> > @@ -431,6 +431,7 @@ bpf_map__prev(const struct bpf_map *map, const struct bpf_object *obj);
> >  /* get/set map FD */
> >  LIBBPF_API int bpf_map__fd(const struct bpf_map *map);
> >  LIBBPF_API int bpf_map__reuse_fd(struct bpf_map *map, int fd);
> > +LIBBPF_API int bpf_object__reuse_map(struct bpf_map *map);
> 
> It's internal function, which doesn't check that map->pin_path is set,

How about add a path check in bpf_object__reuse_map()?

And off course users who use it should call bpf_map__set_pin_path() first.

> for one thing. It shouldn't be exposed. libbpf exposes
> bpf_map__set_pin_path() to set pin_path for any map, and then during
> load time libbpf with "reuse map", if pin_path is not NULL. Doesn't
> that work for you?

Long story...

When trying to add iproute2 libbpf support that I'm working on. We need to
create iproute2 legacy map-in-map manually before libbpf load objects, because
libbpf only support BTF type map-in-map(unless I missed something.).

After creating legacy map-in-map and reuse the fd, if the map has legacy
pining defined, only set the pin path would not enough as libbpf will skip
pinning map if map->fd > 0 in bpf_object__create_maps(). See the following
code bellow.

bpf_map__set_pin_path()
bpf_create_map_in_map()    <- create inner or outer map
bpf_map__reuse_fd(map, inner/outer_fd)
bpf_object__load(obj)
  - bpf_object__load_xattr()
    - bpf_object__create_maps()
      - if (map->fd >= 0)
          continue      <- this will skip pinning map

So when handle legacy map-in-map + pin map, we need to create the map
and pin maps manually at the same time. The code would looks like
(err handler skipped).

map_fd = bpf_obj_get(pathname);
if (map_fd > 0) {
	bpf_map__set_pin_path(map, pathname);
	return bpf_object__reuse_map(map);   <- here we need the reuse_map
}
bpf_create_map_in_map()
bpf_map__reuse_fd(map, map_fd);
bpf_map__pin(map, pathname);

So I think this function is needed, what do you think?

Thanks
Hangbin

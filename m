Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B941618155C
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 10:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgCKJzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 05:55:33 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:42856 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgCKJzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 05:55:33 -0400
Received: by mail-ua1-f68.google.com with SMTP id p2so479543uao.9;
        Wed, 11 Mar 2020 02:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gOgtIbKyNpgTiYxd9upKHF8kXwRIknTOBVABsNn+TZ8=;
        b=a+QLrkgbRZV/TWq5aNFxODHT8hfZpyncjMcuVYdq3g4yvclKIypoZwv8GQbJxa465w
         8FQ0hjutIxFcozxrjjJjGCjVvv9C/zjlg0YvkrgIQyUIy4qu+elcxluy7ulPmk19327C
         Oi1DU+iZl5Qq052+9R++oxFlVgsu+P7Q+YX2cHjJ4aecgYzSeOuQ/ctfo2hjD0oySAgO
         KmCCsKst20OyzGa8qMLCCTXGSYIQieLYJ1dLlPaUML1HmCUnzv/BZS53kYIW9Hf61KF9
         fgsr2Dlhn/s0xnZyesX7+3XSZJQ6XwpaXI78uqANVaTEuSFz+jcHY9GqP+2y151D1F2R
         Y6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gOgtIbKyNpgTiYxd9upKHF8kXwRIknTOBVABsNn+TZ8=;
        b=YBBW+o0SyZFYJzlVQ02mjUGBw773/RJrWoYgz1PNEQwviEsF4BV4ouDU8QXHPCiaLA
         ickTrI1aoeoznMFEHvmqZxomOB2uZ9BgbNpCSrxoT7I9+jE4oGdIHKq5bx2pXbAYPrZ5
         mHBKk7d1VFF+qC9IjObBXJejfjFvbPnZOohm/PNwg74YlhFoluoVgeI0nRvXBaKSBI60
         AP3TY3zUSsI/n2CcorKmQcgT0swEqxDX3BEPwgSyp4sN2wgref8IHTH7OQ6ie3FXaMfo
         pWQkaVucgHnoF3Qyul5a6NkRw0M0gzCnl8Q7QeE6sOkwVBezn6HLCpnCkI9MCtKFD7pP
         etVQ==
X-Gm-Message-State: ANhLgQ2dnug9JHq8aOehDhqZ/eq658dI3W1dnNbGkPgH5+2NRuU+C2UH
        xBcHtph7sknAjcxLS5LfY5jXrYH3srPO7/ON8e8=
X-Google-Smtp-Source: ADFU+vtDQCGNC63oTUVkE96Ddc7reZJm9cqBOiLSaNyN2bKIqZsqXm2crBnYWW4kNuyoG+1++ELB1K3FlZ0ttufLiGI=
X-Received: by 2002:ab0:6e6:: with SMTP id g93mr1163450uag.105.1583920531149;
 Wed, 11 Mar 2020 02:55:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200303093327.8720-1-gmayyyha@gmail.com> <CAOi1vP8jZ2tX_dg90uZY5G8cKX2Lzyu2vrGT_Ew0gVsnK4DDMA@mail.gmail.com>
In-Reply-To: <CAOi1vP8jZ2tX_dg90uZY5G8cKX2Lzyu2vrGT_Ew0gVsnK4DDMA@mail.gmail.com>
From:   Yanhu Cao <gmayyyha@gmail.com>
Date:   Wed, 11 Mar 2020 17:55:19 +0800
Message-ID: <CAB9OAC1+OOgaLF33bSrQ3WeKZyU0qwBqUQzi9MOXwzGta_b2XA@mail.gmail.com>
Subject: Re: [v2] ceph: using POOL FULL flag instead of OSDMAP FULL flag
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 4:43 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Tue, Mar 3, 2020 at 10:33 AM Yanhu Cao <gmayyyha@gmail.com> wrote:
> >
> > CEPH_OSDMAP_FULL/NEARFULL has been deprecated since mimic, so it
> > does not work well in new versions, added POOL flags to handle it.
> >
> > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > ---
> >  fs/ceph/file.c                  |  9 +++++++--
> >  include/linux/ceph/osd_client.h |  2 ++
> >  include/linux/ceph/osdmap.h     |  3 ++-
> >  net/ceph/osd_client.c           | 23 +++++++++++++----------
> >  4 files changed, 24 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 7e0190b1f821..84ec44f9d77a 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1482,7 +1482,9 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >         }
> >
> >         /* FIXME: not complete since it doesn't account for being at quota */
> > -       if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL)) {
> > +       if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL) ||
> > +           pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > +                                               CEPH_POOL_FLAG_FULL)) {
> >                 err = -ENOSPC;
> >                 goto out;
> >         }
> > @@ -1575,7 +1577,10 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >         }
> >
> >         if (written >= 0) {
> > -               if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
> > +               if (ceph_osdmap_flag(&fsc->client->osdc,
> > +                                       CEPH_OSDMAP_NEARFULL) ||
> > +                   pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > +                                       CEPH_POOL_FLAG_NEARFULL))
> >                         iocb->ki_flags |= IOCB_DSYNC;
> >                 written = generic_write_sync(iocb, written);
> >         }
> > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > index 5a62dbd3f4c2..be9007b93862 100644
> > --- a/include/linux/ceph/osd_client.h
> > +++ b/include/linux/ceph/osd_client.h
> > @@ -375,6 +375,8 @@ static inline bool ceph_osdmap_flag(struct ceph_osd_client *osdc, int flag)
> >         return osdc->osdmap->flags & flag;
> >  }
> >
> > +bool pool_flag(struct ceph_osd_client *osdc, s64 pool_id, int flag);
> > +
> >  extern int ceph_osdc_setup(void);
> >  extern void ceph_osdc_cleanup(void);
> >
> > diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
> > index e081b56f1c1d..88faacc11f55 100644
> > --- a/include/linux/ceph/osdmap.h
> > +++ b/include/linux/ceph/osdmap.h
> > @@ -36,7 +36,8 @@ int ceph_spg_compare(const struct ceph_spg *lhs, const struct ceph_spg *rhs);
> >
> >  #define CEPH_POOL_FLAG_HASHPSPOOL      (1ULL << 0) /* hash pg seed and pool id
> >                                                        together */
> > -#define CEPH_POOL_FLAG_FULL            (1ULL << 1) /* pool is full */
> > +#define CEPH_POOL_FLAG_FULL            (1ULL << 1)  /* pool is full */
> > +#define CEPH_POOL_FLAG_NEARFULL        (1ULL << 11) /* pool is nearfull */
> >
> >  struct ceph_pg_pool_info {
> >         struct rb_node node;
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index b68b376d8c2f..9ad2b96c3e78 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -1447,9 +1447,9 @@ static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
> >                 atomic_dec(&osd->o_osdc->num_homeless);
> >  }
> >
> > -static bool __pool_full(struct ceph_pg_pool_info *pi)
> > +static bool __pool_flag(struct ceph_pg_pool_info *pi, int flag)
> >  {
> > -       return pi->flags & CEPH_POOL_FLAG_FULL;
> > +       return pi->flags & flag;
> >  }
> >
> >  static bool have_pool_full(struct ceph_osd_client *osdc)
> > @@ -1460,14 +1460,14 @@ static bool have_pool_full(struct ceph_osd_client *osdc)
> >                 struct ceph_pg_pool_info *pi =
> >                     rb_entry(n, struct ceph_pg_pool_info, node);
> >
> > -               if (__pool_full(pi))
> > +               if (__pool_flag(pi, CEPH_POOL_FLAG_FULL))
> >                         return true;
> >         }
> >
> >         return false;
> >  }
> >
> > -static bool pool_full(struct ceph_osd_client *osdc, s64 pool_id)
> > +bool pool_flag(struct ceph_osd_client *osdc, s64 pool_id, int flag)
> >  {
> >         struct ceph_pg_pool_info *pi;
> >
> > @@ -1475,8 +1475,10 @@ static bool pool_full(struct ceph_osd_client *osdc, s64 pool_id)
> >         if (!pi)
> >                 return false;
> >
> > -       return __pool_full(pi);
> > +       return __pool_flag(pi, flag);
> >  }
> > +EXPORT_SYMBOL(pool_flag);
> > +
> >
> >  /*
> >   * Returns whether a request should be blocked from being sent
> > @@ -1489,7 +1491,7 @@ static bool target_should_be_paused(struct ceph_osd_client *osdc,
> >         bool pauserd = ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSERD);
> >         bool pausewr = ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSEWR) ||
> >                        ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
> > -                      __pool_full(pi);
> > +                      __pool_flag(pi, CEPH_POOL_FLAG_FULL);
> >
> >         WARN_ON(pi->id != t->target_oloc.pool);
> >         return ((t->flags & CEPH_OSD_FLAG_READ) && pauserd) ||
> > @@ -2320,7 +2322,8 @@ static void __submit_request(struct ceph_osd_request *req, bool wrlocked)
> >                    !(req->r_flags & (CEPH_OSD_FLAG_FULL_TRY |
> >                                      CEPH_OSD_FLAG_FULL_FORCE)) &&
> >                    (ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
> > -                   pool_full(osdc, req->r_t.base_oloc.pool))) {
> > +                  pool_flag(osdc, req->r_t.base_oloc.pool,
> > +                            CEPH_POOL_FLAG_FULL))) {
> >                 dout("req %p full/pool_full\n", req);
> >                 if (ceph_test_opt(osdc->client, ABORT_ON_FULL)) {
> >                         err = -ENOSPC;
> > @@ -2539,7 +2542,7 @@ static int abort_on_full_fn(struct ceph_osd_request *req, void *arg)
> >
> >         if ((req->r_flags & CEPH_OSD_FLAG_WRITE) &&
> >             (ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
> > -            pool_full(osdc, req->r_t.base_oloc.pool))) {
> > +            pool_flag(osdc, req->r_t.base_oloc.pool, CEPH_POOL_FLAG_FULL))) {
> >                 if (!*victims) {
> >                         update_epoch_barrier(osdc, osdc->osdmap->epoch);
> >                         *victims = true;
> > @@ -3707,7 +3710,7 @@ static void set_pool_was_full(struct ceph_osd_client *osdc)
> >                 struct ceph_pg_pool_info *pi =
> >                     rb_entry(n, struct ceph_pg_pool_info, node);
> >
> > -               pi->was_full = __pool_full(pi);
> > +               pi->was_full = __pool_flag(pi, CEPH_POOL_FLAG_FULL);
> >         }
> >  }
> >
> > @@ -3719,7 +3722,7 @@ static bool pool_cleared_full(struct ceph_osd_client *osdc, s64 pool_id)
> >         if (!pi)
> >                 return false;
> >
> > -       return pi->was_full && !__pool_full(pi);
> > +       return pi->was_full && !__pool_flag(pi, CEPH_POOL_FLAG_FULL);
> >  }
> >
> >  static enum calc_target_result
>
> Hi Yanhu,
>
> Sorry for a late reply.
>
> This adds some unnecessary churn and also exposes a helper that
> must be called under osdc->lock without making that obvious.  How
> about the attached instead?
>
> ceph_pg_pool_flags() takes osdmap instead of osdc, making it clear
> that the caller is resposibile for keeping the map stable.
>
> Thanks,
>
>                 Ilya

net/ceph/osdmap.c
--------------------------
bool ceph_pg_pool_flags(struct ceph_osdmap *map, s64 pool_id, int flag)
{
        struct ceph_pg_pool_info *pi;

        /* CEPH_OSDMAP_FULL|CEPH_OSDMAP_NEARFULL deprecated since mimic */
        if (flag & (CEPH_POOL_FLAG_FULL|CEPH_POOL_FLAG_NEARFULL))
                if (map->flags & (CEPH_OSDMAP_FULL|CEPH_OSDMAP_NEARFULL))
                        return true;

        pi = ceph_pg_pool_by_id(map, pool_id);
        if (!pi)
                return false;

        return pi->flags & flag;
}

fs/ceph/file.c
-----------------
ceph_write_iter() {
...
        down_read(&osdc->lock);
        if (ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id,
                               CEPH_POOL_FLAG_FULL|CEPH_POOL_FLAG_FULL_QUOTA)) {
                err = -ENOSPC;
                up_read(&osdc->lock);
                goto out;
        }
        up_read(&osdc->lock);
...
         down_read(&osdc->lock);
          if (ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id,
                                        CEPH_POOL_FLAG_NEARFULL))
              iocb->ki_flags |= IOCB_DSYNC;
          up_read(&osdc->lock);
...
}

how about this?

Thanks.

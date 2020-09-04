Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA70D25E349
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 23:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgIDV3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 17:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgIDV33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 17:29:29 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4925FC061246
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 14:29:29 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id z22so10380549ejl.7
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 14:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RRcBN/Qdb8v0KDVNTUWfzE16UEVRp97ohARzpOqPe/Y=;
        b=0NA/6RJUn88ocY0I5He3OBEoMf2p+nwapxWCkw9CPX8bCaqF/KB/xdu4kpUmZX+sKf
         eaChABYOezJkpQlGawPUbVgdnCBxmTFXwH2vYikeadloLzmbhvE49UiY+gpCdNXx3UlB
         e4LuLYG2Zsg79hxJTK+yrvwYtCOJxBDmWOiXi3+4+ZHTeVABs9LEQJVDga0jJpqdd9aU
         moWp1IPVlHvvgd8Ct5AoIsHFfOw7eJQbeoSqdHvd7mcNEPKeLin39A8ZZjKe/zLEhla2
         StaU2EoGq8GIfN5qFKBJLFahzQI6Rd4yn/FLH1HVqRQnURDzyQ/sZNvQOEH82bDClUKz
         1JvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RRcBN/Qdb8v0KDVNTUWfzE16UEVRp97ohARzpOqPe/Y=;
        b=gWzztPInJTjhrJEkz1z0aK1GuF1aDExA6P/MY2kqn2Ngi+SP27I17npy7+YedvcCeS
         MTWOagmokT2rHRiiznW1fBNNtw17uEUZdBzaOfga2ViyIR/NmnCMaPvMchNWTlQkVvEO
         BF5tEslhOIwk/jpAYikcSZASvkKGpbkDWAcotgxcC13uJD0mETCetfTt/0mPrA8Ey2YP
         j3vd37oCW4IgWirKkM8uqQ/tbEElxiI0r1pMyrCmwmGNJ8Jx6FV3iRC1FsFCqEsY2tHN
         s9GvahIOxzCT7TbHy1sEBQLCfVJ1zaz2eyKDqp8bT/adKQk6an7zPOGZMd25Jjl+Ke8e
         6B2g==
X-Gm-Message-State: AOAM533uSVw/6GEbTgqU9tQeJKTSv8KDooyYSiLnBDyIape0Pn0OFjz0
        Ils204mJRsx9Krf/qwZi+alPyUTrEqigkgfnXE5+
X-Google-Smtp-Source: ABdhPJzmzKp2aoYLlizEvr2j8avfdqcyw1Kv+OSU0OK8G8GeyiQ8GRIeSJFEUDZ8eI9EF0Uq6Izx/IkVN2yjce9cUqA=
X-Received: by 2002:a17:906:a415:: with SMTP id l21mr8923828ejz.431.1599254967262;
 Fri, 04 Sep 2020 14:29:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200826145247.10029-1-casey@schaufler-ca.com> <20200826145247.10029-7-casey@schaufler-ca.com>
In-Reply-To: <20200826145247.10029-7-casey@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 4 Sep 2020 17:29:15 -0400
Message-ID: <CAHC9VhR+=nE8B1A9Xv_Zsnp-rQV79+a+2bi26gzEmYO1+3ceQA@mail.gmail.com>
Subject: Re: [PATCH v20 06/23] LSM: Use lsmblob in security_secctx_to_secid
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     casey.schaufler@intel.com, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        Stephen Smalley <sds@tycho.nsa.gov>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 11:08 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
> Change security_secctx_to_secid() to fill in a lsmblob instead
> of a u32 secid. Multiple LSMs may be able to interpret the
> string, and this allows for setting whichever secid is
> appropriate. Change security_secmark_relabel_packet() to use a
> lsmblob instead of a u32 secid. In some other cases there is
> scaffolding where interfaces have yet to be converted.
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: netdev@vger.kernel.org
> ---
>  include/linux/security.h          | 30 +++++++++++++++++++++++----
>  include/net/scm.h                 |  7 +++++--
>  kernel/cred.c                     |  4 +---
>  net/ipv4/ip_sockglue.c            |  6 ++++--
>  net/netfilter/nft_meta.c          | 18 +++++++++-------
>  net/netfilter/xt_SECMARK.c        |  9 ++++++--
>  net/netlabel/netlabel_unlabeled.c | 23 +++++++++++++--------
>  security/security.c               | 34 ++++++++++++++++++++++++++-----
>  8 files changed, 98 insertions(+), 33 deletions(-)

I imagine there may be ways around the xt_secmark_target_info
limitation, but that would require userspace changes to take advantage
of it, and the way forward is clearly nftables so it probably isn't
worth the effort.

I'm okay with this patch with the understanding that several chunks in
the patch are replaced by later patches in the series.

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/include/linux/security.h b/include/linux/security.h
> index ae623b89cdf4..f8770c228356 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -190,6 +190,27 @@ static inline bool lsmblob_equal(struct lsmblob *bloba, struct lsmblob *blobb)
>         return !memcmp(bloba, blobb, sizeof(*bloba));
>  }
>
> +/**
> + * lsmblob_value - find the first non-zero value in an lsmblob structure.
> + * @blob: Pointer to the data
> + *
> + * This needs to be used with extreme caution, as the cases where
> + * it is appropriate are rare.
> + *
> + * Return the first secid value set in the lsmblob.
> + * There should only be one.
> + */
> +static inline u32 lsmblob_value(const struct lsmblob *blob)
> +{
> +       int i;
> +
> +       for (i = 0; i < LSMBLOB_ENTRIES; i++)
> +               if (blob->secid[i])
> +                       return blob->secid[i];
> +
> +       return 0;
> +}
> +
>  /* These functions are in security/commoncap.c */
>  extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
>                        int cap, unsigned int opts);
> @@ -503,7 +524,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
>  int security_netlink_send(struct sock *sk, struct sk_buff *skb);
>  int security_ismaclabel(const char *name);
>  int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
> -int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
> +int security_secctx_to_secid(const char *secdata, u32 seclen,
> +                            struct lsmblob *blob);
>  void security_release_secctx(char *secdata, u32 seclen);
>  void security_inode_invalidate_secctx(struct inode *inode);
>  int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
> @@ -1322,7 +1344,7 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
>
>  static inline int security_secctx_to_secid(const char *secdata,
>                                            u32 seclen,
> -                                          u32 *secid)
> +                                          struct lsmblob *blob)
>  {
>         return -EOPNOTSUPP;
>  }
> @@ -1412,7 +1434,7 @@ void security_inet_csk_clone(struct sock *newsk,
>                         const struct request_sock *req);
>  void security_inet_conn_established(struct sock *sk,
>                         struct sk_buff *skb);
> -int security_secmark_relabel_packet(u32 secid);
> +int security_secmark_relabel_packet(struct lsmblob *blob);
>  void security_secmark_refcount_inc(void);
>  void security_secmark_refcount_dec(void);
>  int security_tun_dev_alloc_security(void **security);
> @@ -1585,7 +1607,7 @@ static inline void security_inet_conn_established(struct sock *sk,
>  {
>  }
>
> -static inline int security_secmark_relabel_packet(u32 secid)
> +static inline int security_secmark_relabel_packet(struct lsmblob *blob)
>  {
>         return 0;
>  }
> diff --git a/include/net/scm.h b/include/net/scm.h
> index e2e71c4bf9d0..c09f2dfeec88 100644
> --- a/include/net/scm.h
> +++ b/include/net/scm.h
> @@ -97,8 +97,11 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
>         int err;
>
>         if (test_bit(SOCK_PASSSEC, &sock->flags)) {
> -               /* Scaffolding - it has to be element 0 for now */
> -               err = security_secid_to_secctx(scm->lsmblob.secid[0],
> +               /* There can currently be only one value in the lsmblob,
> +                * so getting it from lsmblob_value is appropriate until
> +                * security_secid_to_secctx() is converted to taking a
> +                * lsmblob directly. */
> +               err = security_secid_to_secctx(lsmblob_value(&scm->lsmblob),
>                                                &secdata, &seclen);
>
>                 if (!err) {
> diff --git a/kernel/cred.c b/kernel/cred.c
> index 22e0e7cbefde..848306c7d823 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -757,14 +757,12 @@ EXPORT_SYMBOL(set_security_override);
>  int set_security_override_from_ctx(struct cred *new, const char *secctx)
>  {
>         struct lsmblob blob;
> -       u32 secid;
>         int ret;
>
> -       ret = security_secctx_to_secid(secctx, strlen(secctx), &secid);
> +       ret = security_secctx_to_secid(secctx, strlen(secctx), &blob);
>         if (ret < 0)
>                 return ret;
>
> -       lsmblob_init(&blob, secid);
>         return set_security_override(new, &blob);
>  }
>  EXPORT_SYMBOL(set_security_override_from_ctx);
> diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> index 551dfbc717e9..c568574abfae 100644
> --- a/net/ipv4/ip_sockglue.c
> +++ b/net/ipv4/ip_sockglue.c
> @@ -139,8 +139,10 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
>         if (err)
>                 return;
>
> -       /* Scaffolding - it has to be element 0 */
> -       err = security_secid_to_secctx(lb.secid[0], &secdata, &seclen);
> +       /* There can only be one secid in the lsmblob at this point,
> +        * so getting it using lsmblob_value() is sufficient until
> +        * security_secid_to_secctx() is changed to use a lsmblob */
> +       err = security_secid_to_secctx(lsmblob_value(&lb), &secdata, &seclen);
>         if (err)
>                 return;
>
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 7bc6537f3ccb..7db487d93618 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -801,7 +801,7 @@ struct nft_expr_type nft_meta_type __read_mostly = {
>
>  #ifdef CONFIG_NETWORK_SECMARK
>  struct nft_secmark {
> -       u32 secid;
> +       struct lsmblob lsmdata;
>         char *ctx;
>  };
>
> @@ -811,21 +811,21 @@ static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
>
>  static int nft_secmark_compute_secid(struct nft_secmark *priv)
>  {
> -       u32 tmp_secid = 0;
> +       struct lsmblob blob;
>         int err;
>
> -       err = security_secctx_to_secid(priv->ctx, strlen(priv->ctx), &tmp_secid);
> +       err = security_secctx_to_secid(priv->ctx, strlen(priv->ctx), &blob);
>         if (err)
>                 return err;
>
> -       if (!tmp_secid)
> +       if (!lsmblob_is_set(&blob))
>                 return -ENOENT;
>
> -       err = security_secmark_relabel_packet(tmp_secid);
> +       err = security_secmark_relabel_packet(&blob);
>         if (err)
>                 return err;
>
> -       priv->secid = tmp_secid;
> +       priv->lsmdata = blob;
>         return 0;
>  }
>
> @@ -835,7 +835,11 @@ static void nft_secmark_obj_eval(struct nft_object *obj, struct nft_regs *regs,
>         const struct nft_secmark *priv = nft_obj_data(obj);
>         struct sk_buff *skb = pkt->skb;
>
> -       skb->secmark = priv->secid;
> +       /* It is not possible for more than one secid to be set in
> +        * the lsmblob structure because it is set using
> +        * security_secctx_to_secid(). Any secid that is set must therefore
> +        * be the one that should go in the secmark. */
> +       skb->secmark = lsmblob_value(&priv->lsmdata);
>  }
>
>  static int nft_secmark_obj_init(const struct nft_ctx *ctx,
> diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
> index 75625d13e976..5a268707eeda 100644
> --- a/net/netfilter/xt_SECMARK.c
> +++ b/net/netfilter/xt_SECMARK.c
> @@ -43,13 +43,14 @@ secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
>
>  static int checkentry_lsm(struct xt_secmark_target_info *info)
>  {
> +       struct lsmblob blob;
>         int err;
>
>         info->secctx[SECMARK_SECCTX_MAX - 1] = '\0';
>         info->secid = 0;
>
>         err = security_secctx_to_secid(info->secctx, strlen(info->secctx),
> -                                      &info->secid);
> +                                      &blob);
>         if (err) {
>                 if (err == -EINVAL)
>                         pr_info_ratelimited("invalid security context \'%s\'\n",
> @@ -57,13 +58,17 @@ static int checkentry_lsm(struct xt_secmark_target_info *info)
>                 return err;
>         }
>
> +       /* xt_secmark_target_info can't be changed to use lsmblobs because
> +        * it is exposed as an API. Use lsmblob_value() to get the one
> +        * value that got set by security_secctx_to_secid(). */
> +       info->secid = lsmblob_value(&blob);
>         if (!info->secid) {
>                 pr_info_ratelimited("unable to map security context \'%s\'\n",
>                                     info->secctx);
>                 return -ENOENT;
>         }
>
> -       err = security_secmark_relabel_packet(info->secid);
> +       err = security_secmark_relabel_packet(&blob);
>         if (err) {
>                 pr_info_ratelimited("unable to obtain relabeling permission\n");
>                 return err;
> diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
> index 77bb1bb22c3b..8948557eaebb 100644
> --- a/net/netlabel/netlabel_unlabeled.c
> +++ b/net/netlabel/netlabel_unlabeled.c
> @@ -882,7 +882,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
>         void *addr;
>         void *mask;
>         u32 addr_len;
> -       u32 secid;
> +       struct lsmblob blob;
>         struct netlbl_audit audit_info;
>
>         /* Don't allow users to add both IPv4 and IPv6 addresses for a
> @@ -906,13 +906,18 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
>         ret_val = security_secctx_to_secid(
>                                   nla_data(info->attrs[NLBL_UNLABEL_A_SECCTX]),
>                                   nla_len(info->attrs[NLBL_UNLABEL_A_SECCTX]),
> -                                 &secid);
> +                                 &blob);
>         if (ret_val != 0)
>                 return ret_val;
>
> +       /* netlbl_unlhsh_add will be changed to pass a struct lsmblob *
> +        * instead of a u32 later in this patch set. security_secctx_to_secid()
> +        * will only be setting one entry in the lsmblob struct, so it is
> +        * safe to use lsmblob_value() to get that one value. */
> +
>         return netlbl_unlhsh_add(&init_net,
> -                                dev_name, addr, mask, addr_len, secid,
> -                                &audit_info);
> +                                dev_name, addr, mask, addr_len,
> +                                lsmblob_value(&blob), &audit_info);
>  }
>
>  /**
> @@ -933,7 +938,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
>         void *addr;
>         void *mask;
>         u32 addr_len;
> -       u32 secid;
> +       struct lsmblob blob;
>         struct netlbl_audit audit_info;
>
>         /* Don't allow users to add both IPv4 and IPv6 addresses for a
> @@ -955,13 +960,15 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
>         ret_val = security_secctx_to_secid(
>                                   nla_data(info->attrs[NLBL_UNLABEL_A_SECCTX]),
>                                   nla_len(info->attrs[NLBL_UNLABEL_A_SECCTX]),
> -                                 &secid);
> +                                 &blob);
>         if (ret_val != 0)
>                 return ret_val;
>
> +       /* security_secctx_to_secid() will only put one secid into the lsmblob
> +        * so it's safe to use lsmblob_value() to get the secid. */
>         return netlbl_unlhsh_add(&init_net,
> -                                NULL, addr, mask, addr_len, secid,
> -                                &audit_info);
> +                                NULL, addr, mask, addr_len,
> +                                lsmblob_value(&blob), &audit_info);
>  }
>
>  /**
> diff --git a/security/security.c b/security/security.c
> index c42873876954..5c2ed1db0658 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2065,10 +2065,22 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
>  }
>  EXPORT_SYMBOL(security_secid_to_secctx);
>
> -int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
> +int security_secctx_to_secid(const char *secdata, u32 seclen,
> +                            struct lsmblob *blob)
>  {
> -       *secid = 0;
> -       return call_int_hook(secctx_to_secid, 0, secdata, seclen, secid);
> +       struct security_hook_list *hp;
> +       int rc;
> +
> +       lsmblob_init(blob, 0);
> +       hlist_for_each_entry(hp, &security_hook_heads.secctx_to_secid, list) {
> +               if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
> +                       continue;
> +               rc = hp->hook.secctx_to_secid(secdata, seclen,
> +                                             &blob->secid[hp->lsmid->slot]);
> +               if (rc != 0)
> +                       return rc;
> +       }
> +       return 0;
>  }
>  EXPORT_SYMBOL(security_secctx_to_secid);
>
> @@ -2301,9 +2313,21 @@ void security_inet_conn_established(struct sock *sk,
>  }
>  EXPORT_SYMBOL(security_inet_conn_established);
>
> -int security_secmark_relabel_packet(u32 secid)
> +int security_secmark_relabel_packet(struct lsmblob *blob)
>  {
> -       return call_int_hook(secmark_relabel_packet, 0, secid);
> +       struct security_hook_list *hp;
> +       int rc = 0;
> +
> +       hlist_for_each_entry(hp, &security_hook_heads.secmark_relabel_packet,
> +                            list) {
> +               if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
> +                       continue;
> +               rc = hp->hook.secmark_relabel_packet(
> +                                               blob->secid[hp->lsmid->slot]);
> +               if (rc != 0)
> +                       break;
> +       }
> +       return rc;
>  }
>  EXPORT_SYMBOL(security_secmark_relabel_packet);
>
> --
> 2.24.1
>


--
paul moore
www.paul-moore.com

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509A4D3641
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfJKAjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:39:37 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46389 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727510AbfJKAjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:39:37 -0400
Received: by mail-lj1-f196.google.com with SMTP id d1so7996445ljl.13
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hNUOlKgtAsIE5sVaiGZXUcvdRA2PQ04IbA6oz24c6V8=;
        b=iP81mvJ6NRHztHSh53vzlkBNXKSKrdUZFa4QghmB7J5WhFdcG7DP8odULQ1+LossNA
         HyY0EtjSe+2D65p1cF1RolTRImCUmAhtf34UnnJiv5bb4byWcyiu0rvjrmfl2vbW40+K
         uYDLMHcrUwNLTf4ZMgF+AbSbAFzYG0VlkyZVjWslSX3CfO8wHTZpCXr6615M3Yfpj4l0
         8f2g26wlubWzyKR8Pe5U+v+67VdFF5Q1pQ0ct6gdTXUOBEg2ZBgOPL9yrMl6iozvVkf1
         p+2xg2upTdzGk4pdFz6YYWPnDIYnEiY4bZ7ccwy25bJtoqymfHPpN9PGVFPFLhREQFOY
         jCcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hNUOlKgtAsIE5sVaiGZXUcvdRA2PQ04IbA6oz24c6V8=;
        b=WHxo25S2ypjGrLrGzP4hbwW8ByPYrEw0mpFHsfaMQ7PO3r0FiIP09KgjG32UOsLqzP
         6C/ZK7FdkhH2J1wwFzDCTnqnl+buaesKP44vOCvx3gVGfcQc6JvlmjgWoHh3WyH4raRK
         ogpvl5jG/G4+GBhWxrJ7hm1kMox0jNZ395KKEq60eXVuCY2mSTQNAMtZx9f47UHjJAj8
         FWFttl4j2X82s0mmDNKjIGJQ271k+Zx1B2WZmhKhTA+snbMYUYYmca9jG/kkGjhV3mcz
         14NcDV6gaRSRPs3p6ax10avjmZJGGXifP4fNTIvWDPToEqmfCCVPi61z+VwRhlvs9QAt
         DgQw==
X-Gm-Message-State: APjAAAUdD+xUqJz90CH5nzA57plTXpmvAI/nPtcj2kVmuz2+y4FiRfpX
        Kt9WCJ/X43D5Dqerlvde4owBSqsEBk3vEZd85Tbe
X-Google-Smtp-Source: APXvYqwpaPJtcZV1PwuU4AeNVWnL9+Nw3+LElDHT8e77zerC7lPTAOUcw5b4UEWy9HlrwEw0xG4KWIzRTp7isyiM8F8=
X-Received: by 2002:a2e:6e18:: with SMTP id j24mr1202454ljc.57.1570754372500;
 Thu, 10 Oct 2019 17:39:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <0850eaa785e2ff30c8c4818fd53e9544b34ed884.1568834524.git.rgb@redhat.com>
In-Reply-To: <0850eaa785e2ff30c8c4818fd53e9544b34ed884.1568834524.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 10 Oct 2019 20:39:21 -0400
Message-ID: <CAHC9VhQoFFaQACbV4QHG_NPUCJu1+V=x3=i-yyGjbsYq8HuPtg@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 08/21] audit: add contid support for signalling
 the audit daemon
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 9:25 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add audit container identifier support to the action of signalling the
> audit daemon.
>
> Since this would need to add an element to the audit_sig_info struct,
> a new record type AUDIT_SIGNAL_INFO2 was created with a new
> audit_sig_info2 struct.  Corresponding support is required in the
> userspace code to reflect the new record request and reply type.
> An older userspace won't break since it won't know to request this
> record type.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h       |  7 +++++++
>  include/uapi/linux/audit.h  |  1 +
>  kernel/audit.c              | 28 ++++++++++++++++++++++++++++
>  kernel/audit.h              |  1 +
>  security/selinux/nlmsgtab.c |  1 +
>  5 files changed, 38 insertions(+)
>
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 0c18d8e30620..7b640c4da4ee 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -23,6 +23,13 @@ struct audit_sig_info {
>         char            ctx[0];
>  };
>
> +struct audit_sig_info2 {
> +       uid_t           uid;
> +       pid_t           pid;
> +       u64             cid;
> +       char            ctx[0];
> +};
> +
>  struct audit_buffer;
>  struct audit_context;
>  struct inode;
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 4ed080f28b47..693ec6e0288b 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -72,6 +72,7 @@
>  #define AUDIT_SET_FEATURE      1018    /* Turn an audit feature on or off */
>  #define AUDIT_GET_FEATURE      1019    /* Get which features are enabled */
>  #define AUDIT_CONTAINER_OP     1020    /* Define the container id and info */
> +#define AUDIT_SIGNAL_INFO2     1021    /* Get info auditd signal sender */
>
>  #define AUDIT_FIRST_USER_MSG   1100    /* Userspace messages mostly uninteresting to kernel */
>  #define AUDIT_USER_AVC         1107    /* We filter this differently */
> diff --git a/kernel/audit.c b/kernel/audit.c
> index adfb3e6a7f0c..df3db29f5a8a 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -125,6 +125,7 @@ struct audit_net {
>  kuid_t         audit_sig_uid = INVALID_UID;
>  pid_t          audit_sig_pid = -1;
>  u32            audit_sig_sid = 0;
> +u64            audit_sig_cid = AUDIT_CID_UNSET;
>
>  /* Records can be lost in several ways:
>     0) [suppressed in audit_alloc]
> @@ -1094,6 +1095,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
>         case AUDIT_ADD_RULE:
>         case AUDIT_DEL_RULE:
>         case AUDIT_SIGNAL_INFO:
> +       case AUDIT_SIGNAL_INFO2:
>         case AUDIT_TTY_GET:
>         case AUDIT_TTY_SET:
>         case AUDIT_TRIM:
> @@ -1257,6 +1259,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>         struct audit_buffer     *ab;
>         u16                     msg_type = nlh->nlmsg_type;
>         struct audit_sig_info   *sig_data;
> +       struct audit_sig_info2  *sig_data2;
>         char                    *ctx = NULL;
>         u32                     len;
>
> @@ -1516,6 +1519,30 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>                                  sig_data, sizeof(*sig_data) + len);
>                 kfree(sig_data);
>                 break;
> +       case AUDIT_SIGNAL_INFO2:
> +               len = 0;
> +               if (audit_sig_sid) {
> +                       err = security_secid_to_secctx(audit_sig_sid, &ctx, &len);
> +                       if (err)
> +                               return err;
> +               }
> +               sig_data2 = kmalloc(sizeof(*sig_data2) + len, GFP_KERNEL);
> +               if (!sig_data2) {
> +                       if (audit_sig_sid)
> +                               security_release_secctx(ctx, len);
> +                       return -ENOMEM;
> +               }
> +               sig_data2->uid = from_kuid(&init_user_ns, audit_sig_uid);
> +               sig_data2->pid = audit_sig_pid;
> +               if (audit_sig_sid) {
> +                       memcpy(sig_data2->ctx, ctx, len);
> +                       security_release_secctx(ctx, len);
> +               }
> +               sig_data2->cid = audit_sig_cid;
> +               audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO2, 0, 0,
> +                                sig_data2, sizeof(*sig_data2) + len);
> +               kfree(sig_data2);
> +               break;
>         case AUDIT_TTY_GET: {
>                 struct audit_tty_status s;
>                 unsigned int t;
> @@ -2384,6 +2411,7 @@ int audit_signal_info(int sig, struct task_struct *t)
>                 else
>                         audit_sig_uid = uid;
>                 security_task_getsecid(current, &audit_sig_sid);
> +               audit_sig_cid = audit_get_contid(current);
>         }

I've been wondering something as I've been working my way through
these patches and this patch seems like a good spot to discuss this
... Now that we have the concept of an audit container ID "lifetime"
in the kernel, when do we consider the ID gone?  Is it when the last
process in the container exits, or is it when we generate the last
audit record which could possibly contain the audit container ID?
This patch would appear to support the former, but if we wanted the
latter we would need to grab a reference to the audit container ID
struct so it wouldn't "die" on us before we could emit the signal info
record.

--
paul moore
www.paul-moore.com

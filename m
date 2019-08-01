Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAE97E126
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 19:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731782AbfHARfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 13:35:41 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35308 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729890AbfHARfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 13:35:41 -0400
Received: by mail-pg1-f194.google.com with SMTP id s1so28290182pgr.2;
        Thu, 01 Aug 2019 10:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=cmtOeJgUg1mSCwNm5Vv4F5lxhgDIyj0LXvGIj3jOCDo=;
        b=cBSjLTF2IQo34tFeZp7/IqR8VhIt+1dXBxPWecfXJqSnP2DwW+enMoLtI62r3LrTM6
         RJNIpu4wOEW3iwm9pRZ7TgHxAwqQ0tqOd00fV4NvMa/BXCjtoziu3jtaKZDjmc9OaDet
         Vt0Q8Au7e+5Dcv0Z8pPhTXv8Ks/KNeyDx+RLGbcww7Z8dChPiYAGpmO+0OKB7W1lxQX8
         dqP4QOxJQUEuYiQYED5LNY/5PHyo1ZMPZao90anVisdMkFVLGN3ufVjSOn0LzERAQRGs
         2nbCICF+U6ugts750bn90UPiDhdaz0Qyotg5/se/FHHxvjlDncBrKFcNRadMbwlnm1JD
         S1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=cmtOeJgUg1mSCwNm5Vv4F5lxhgDIyj0LXvGIj3jOCDo=;
        b=G2A2SrhFagTPgJm2P8oU5v89LBGKZ/cmMCzGo53cHR+cTSs7lvmZL3nTJmgqdcanIv
         YzGE9PUFA3mrsu68o/2sLnPilUt1Ekv2V3eX7HSF+gnZB9ibdhcc0TI2YpWHpkoNLxoB
         tCUyR7J2NWuQZmxH6cN2KZ0I87D7CAuyHR2rqCE7MAcwxbRet1n6N14Or+SpCL+ducWh
         QU6jU2U8jr1TdQ2IJolDFqh+hHw16wy4JDWO4WrsXQHQ1GrkQDrlpHHx04NGKaWhOVZz
         OJcvyjszWsS2zXiDHkil5m739n4KO6S2Exg8CU8uPYZV8o7GY9Dukdf4rZAZtURz2Xw4
         H96A==
X-Gm-Message-State: APjAAAXfzZKJfjqVTS4ehC0eKOFIghzKIwNllI1Em+D+A7IjP6WvKJ7U
        XgmFFPcLObya7W9wtHfYH6k=
X-Google-Smtp-Source: APXvYqzI3/bdzyfwxz0PsvQhshGMsCzZlPOo9cdI9g9+T6qhAyPP0PsvTtGvkAuBeX3ygym6rsavSw==
X-Received: by 2002:a62:1ac9:: with SMTP id a192mr14756335pfa.260.1564680939408;
        Thu, 01 Aug 2019 10:35:39 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:f96b])
        by smtp.gmail.com with ESMTPSA id t7sm4692959pjq.15.2019.08.01.10.35.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 10:35:38 -0700 (PDT)
Date:   Thu, 1 Aug 2019 10:35:36 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>
Cc:     =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v10 06/10] bpf,landlock: Add a new map type:
 inode
Message-ID: <20190801173534.etfls5ltixp5hfrh@ast-mbp.dhcp.thefacebook.com>
References: <20190721213116.23476-1-mic@digikod.net>
 <20190721213116.23476-7-mic@digikod.net>
 <20190727014048.3czy3n2hi6hfdy3m@ast-mbp.dhcp.thefacebook.com>
 <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
 <CAADnVQLqkfVijWoOM29PxCL_yK6K0fr8B89r4c5EKgddevJhGQ@mail.gmail.com>
 <59e8fab9-34df-0ebe-ca6b-8b34bf582b75@ssi.gouv.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <59e8fab9-34df-0ebe-ca6b-8b34bf582b75@ssi.gouv.fr>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 09:11:10PM +0200, Mickaël Salaün wrote:
> 
> 
> On 31/07/2019 20:58, Alexei Starovoitov wrote:
> > On Wed, Jul 31, 2019 at 11:46 AM Mickaël Salaün
> > <mickael.salaun@ssi.gouv.fr> wrote:
> >>>> +    for (i = 0; i < htab->n_buckets; i++) {
> >>>> +            head = select_bucket(htab, i);
> >>>> +            hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
> >>>> +                    landlock_inode_remove_map(*((struct inode **)l->key), map);
> >>>> +            }
> >>>> +    }
> >>>> +    htab_map_free(map);
> >>>> +}
> >>>
> >>> user space can delete the map.
> >>> that will trigger inode_htab_map_free() which will call
> >>> landlock_inode_remove_map().
> >>> which will simply itereate the list and delete from the list.
> >>
> >> landlock_inode_remove_map() removes the reference to the map (being
> >> freed) from the inode (with an RCU lock).
> >
> > I'm going to ignore everything else for now and focus only on this bit,
> > since it's fundamental issue to address before this discussion can
> > go any further.
> > rcu_lock is not a spin_lock. I'm pretty sure you know this.
> > But you're arguing that it's somehow protecting from the race
> > I mentioned above?
> >
> 
> I was just clarifying your comment to avoid misunderstanding about what
> is being removed.
> 
> As said in the full response, there is currently a race but, if I add a
> bpf_map_inc() call when the map is referenced by inode->security, then I
> don't see how a race could occur because such added map could only be
> freed in a security_inode_free() (as long as it retains a reference to
> this inode).

then it will be a cycle and a map will never be deleted?
closing map_fd should delete a map. It cannot be alive if it's not
pinned in bpffs, there are no FDs that are holding it, and no progs using it.
So the map deletion will iterate over inodes that belong to this map.
In parallel security_inode_free() will be called that will iterate
over its link list that contains elements from different maps.
So the same link list is modified by two cpus.
Where is a lock that protects from concurrent links list manipulations?

> Les données à caractère personnel recueillies et traitées dans le cadre de cet échange, le sont à seule fin d’exécution d’une relation professionnelle et s’opèrent dans cette seule finalité et pour la durée nécessaire à cette relation. Si vous souhaitez faire usage de vos droits de consultation, de rectification et de suppression de vos données, veuillez contacter contact.rgpd@sgdsn.gouv.fr. Si vous avez reçu ce message par erreur, nous vous remercions d’en informer l’expéditeur et de détruire le message. The personal data collected and processed during this exchange aims solely at completing a business relationship and is limited to the necessary duration of that relationship. If you wish to use your rights of consultation, rectification and deletion of your data, please contact: contact.rgpd@sgdsn.gouv.fr. If you have received this message in error, we thank you for informing the sender and destroying the message.

Please get rid of this. It's absolutely not appropriate on public mailing list.
Next time I'd have to ignore emails that contain such disclaimers.


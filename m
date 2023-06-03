Return-Path: <netdev+bounces-7669-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C112721062
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 16:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 385B6281A25
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69041D2EF;
	Sat,  3 Jun 2023 14:15:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AD2D2E2
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 14:15:36 +0000 (UTC)
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B75132
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:15:34 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-561b7729a12so66670337b3.1
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 07:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685801734; x=1688393734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81BdzQmvpOd43oW7DVN/QInUY4zIL4Zo5BfqEsykaSM=;
        b=0pPW7JEh8JkJrPZSnEk56KI8qGnaNmXX72UDCVnhiHxDPXzAVZtQFyUcNZmdgCCE7C
         HQhgFXHltnbMZLHee2RsrXxM/xYQPudxQLuJcaBqRQCW5B3KkNCp6pjzbLqgtI7tWkMw
         gsdR7XXmy6lYNaNJhKtzmkQR0Dnf6sF0wAHaBYtuTsU8vFye9r6e+/A7J9BmJUmB573k
         E2EHRNPbiLvCA3s/IO2dFxSp9XPUDrGlSY+JDZIVZ2Cg8wWHMgF5yQ4NwHJGL22OZxV5
         v9/MhYs2YrGEzKDvUjuhHfoO6ktPtS9cMlzdO0SlyPwy536eG7mmidncjNlUTUYuIXjW
         JZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685801734; x=1688393734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=81BdzQmvpOd43oW7DVN/QInUY4zIL4Zo5BfqEsykaSM=;
        b=Han1co4L8aLCU/Mu6UZl9+sSWQJNgjTI775BBTOP0zQ7/JM1er4RtoHwEAKdJnSYC0
         imLuugaSR9AqqnMbTrE7dQ7A8invn4AxP9K9nsQucW+tohINMqxmK21wCgzAfvx/Wmab
         O4oXHUMAMRBXpRq7cxyNVfvSNAdug5NZtE4ED7rQ5AIBq3ytsBZXhza0Iu70ROsBlaOM
         EY4Tkmer60orObzvFhJAjzR+OKFeLcBpcIWiWgJSZ8YYRVUJETa93ThuabbevDix2dgn
         OYYUReP81LrmRjZuU+cfvf1j66w8wmFk2+dhrIjsh9/HXAEHlU02pN1P+hyCUYJoUy1X
         06Vg==
X-Gm-Message-State: AC+VfDz3GYvLP4BPP0EAw/VmHCRGAgzbiHgBSYPen8dg9Yae/DAevoBZ
	6Lwulu81DW+SqxPWHdEpAGy4r5mEwZlM9I0QNxKvMg==
X-Google-Smtp-Source: ACHHUZ7RPBE4bF6i8MJ2fBTyXfIg0rUB0QU9FJA1vSDpuUOYZ5nImpC4wiFcGfPge1iO1/m+tAhdFL6dmAeOtPLME1M=
X-Received: by 2002:a0d:ccca:0:b0:568:b105:751 with SMTP id
 o193-20020a0dccca000000b00568b1050751mr3561025ywd.2.1685801733962; Sat, 03
 Jun 2023 07:15:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-14-jhs@mojatatu.com>
 <CALnP8ZbeMnSL_aHnzK-V=exWNCKjcpZf5P0x8XukJeooX4KxKg@mail.gmail.com>
In-Reply-To: <CALnP8ZbeMnSL_aHnzK-V=exWNCKjcpZf5P0x8XukJeooX4KxKg@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 3 Jun 2023 10:15:22 -0400
Message-ID: <CAM0EoM=tD8A7fgHW0YZs93zS33qhbSh99RxYEuSH2Y+yEsMT7A@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 14/28] p4tc: add table create, update,
 delete, get, flush and dump
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

On Fri, Jun 2, 2023 at 5:54=E2=80=AFPM Marcelo Ricardo Leitner
<mleitner@redhat.com> wrote:
>
> On Wed, May 17, 2023 at 07:02:18AM -0400, Jamal Hadi Salim wrote:
> ...
> > ___Initial Table Entries___
> ...
> > They would get:
> >
> > pipeline id 22
> >     table id 1
> >     table name cb/tname
> >     key_sz 64
> >     max entries 256
> >     masks 8
> >     table entries 1
> >     permissions CRUD--R--X
> >     entry:
> >         table id 1
> >         entry priority 17
> >         key blob    101010a0a0a0a
> >         mask blob   ffffff00ffffff
>
> I'm wondering how these didn't align. Perhaps key had an extra 0 to
> the left? It would be nice to right-align it.

It would also help if we prefixed with "0x". The hard part would be to
use proper format for variable sized fields. Yes i think the zero in
this case is not displayed. We actually should fix this example
because the (compiler) generated introspection file helps us make this
more readable so we dont need to print it in hex. Slightly different
example.
-----
pipeline:  redirect_srcip(id 1)
 table: MainControlImpl/nh_table(id 1)entry priority 1[permissions -RUD--R-=
-X]
    entry key
        srcAddr id:1 size:32b type:ipv4 exact fieldval  200.221.244.192/32
    created by: tc (id 2)
    created 178 sec    used 178 sec
----

The json output (with -j) looks prettier.
---
[
  {
    "pname": "redirect_srcip",
    "pipeid": 1
  },
  {
    "entries": [
      {
        "tblname": "MainControlImpl/nh_table",
        "tblid": 1,
        "prio": 1,
        "permissions": "-RUD--R--X",
        "key": [
          {
            "keyfield": "srcAddr",
            "id": 1,
            "width": 32,
            "type": "ipv4",
            "match_type": "exact",
            "fieldval": "200.221.244.192/32"
          }
        ],
        "create_whodunnit": "tc",
        "create_whodunnit_id": 2,
        "created": 88,
        "last_used": 88
      }
    ]
  }
-----

We'll fix the typos you found.

cheers,
jamal


> >         create whodunnit tc
> >         permissions -RUD--R--X
> >
> ...
> > +static int tcf_key_try_set_state_ready(struct p4tc_table_key *key,
> > +                                    struct netlink_ext_ack *extack)
> > +{
> > +     if (!key->key_acts) {
> > +             NL_SET_ERR_MSG(extack,
> > +                            "Table key must have actions before sealin=
g pipelline");
>
> While at it, so that I don't forget stuff..
> s/pipelline/pipeline/
>
> > +             return -EINVAL;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int __tcf_table_try_set_state_ready(struct p4tc_table *table,
> > +                                        struct netlink_ext_ack *extack=
)
> > +{
> > +     int i;
> > +     int ret;
> > +
> > +     if (!table->tbl_postacts) {
> > +             NL_SET_ERR_MSG(extack,
> > +                            "All tables must have postactions before s=
ealing pipelline");
>
> Same.
>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154B9626EEF
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 11:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbiKMKWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 05:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbiKMKWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 05:22:35 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FCC11801
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 02:22:34 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id i3so8551614pfc.11
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 02:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xbiJG2nvJvN3b7ywG36TMHnfX1FmAXSbyZNk2mZ62aA=;
        b=AV2OYbtAjGUf7Ghl146ADsSCrl+GMSJ/9mqWqNbRw5g6vMD6c1y1nKo7oa/jIJS67I
         gQYhQOGI3h8DpIZTtWqZPKirKMesc1diLAXkyuhmp3lTbF16bytmMx0RVBO42jptKbWq
         2AA4VcSqcThR07TOYAirahQngI3a/clhxhtPozs8CDZ7W8jrX4VtYoY07r3KdcsIs/PO
         imH/5DCkRB9GnOkGFT18h0WMB7E1331eYSdnr4bj8TEgbz5JXVJds5AANrFOMRaKFk6j
         7ULlbsuVfdnS/S6vo8u7nopztx7HMMbBsKJPJC4pOe8zMRWS9URC/WILYB78DWlbrAYM
         Wa5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xbiJG2nvJvN3b7ywG36TMHnfX1FmAXSbyZNk2mZ62aA=;
        b=cg1LUDx57PyS3z6FQKEDMnXY1mfIQlvrO7Ft0OnlUyhq8co5ziNhjr1lgwYlri1UuB
         zBov/CG6SwhcLjDDXCXIePpLO8gWZDKh80ldJOG9iKt0flc+iLxjS6IilaEjLmVOLdwS
         ALcRPh2lIGbjqCKiZ8Fv5e+wrG8IqIsR2Lhnk7PpQthuuApQxP0lhaXhhr1fgUDdabA3
         4CrBBNNUWof5zq/+MFF4LVU7zHeVtZfwLyx4UyiISTaZMhxBSDo1PCixTTe3z+Z+ok9N
         48oxsCju0BHECYnTZm6pxFaE5zsTLbr/19EMhfj7TnOmFjcyfhbFqf9cc6b8ldbpqkIP
         br6g==
X-Gm-Message-State: ANoB5pmfokS0a085QasOW/W/OFi8DO2FacR7fd26n6Bh5zvPtBvxtQTi
        H98L06wtRW5zXtD5dMgSm4xNB4Ahmeq5JomH0qzCW5qseuY=
X-Google-Smtp-Source: AA0mqf4IV/CuRgpVfwxC+UcjNTLeLDETeKYtOWHVaM1cOOmBacc06SrPG95E+PQal65vNCDYtO6+oOmTeCLjUY+BrHY=
X-Received: by 2002:a63:181e:0:b0:470:f0c:96da with SMTP id
 y30-20020a63181e000000b004700f0c96damr7798398pgl.544.1668334953633; Sun, 13
 Nov 2022 02:22:33 -0800 (PST)
MIME-Version: 1.0
References: <CAL87dS2SS9rjLUPnwufh9a0O-Cu-hMAUU7Xa534mXTB9v=KM5g@mail.gmail.com>
In-Reply-To: <CAL87dS2SS9rjLUPnwufh9a0O-Cu-hMAUU7Xa534mXTB9v=KM5g@mail.gmail.com>
From:   mingkun bian <bianmingkun@gmail.com>
Date:   Sun, 13 Nov 2022 18:22:22 +0800
Message-ID: <CAL87dS1Cvbxczdyk_2nviC=M2S91bMRKPXrkp1PLHXFuX=CuKg@mail.gmail.com>
Subject: Re: [ISSUE] suspicious sock leak
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

bpf map1:
key: cookie
value: addr daddr sport dport cookie sock*

bpf map2:
key: sock*
value: addr daddr sport dport cookie sock*

1. Recv a "HTTP GET" request in user applicatoin
map1.insert(cookie, value)
map2.insert(sock*, value)

1. kprobe inet_csk_destroy_sock:
sk->sk_wmem_queued is 0
sk->sk_wmem_alloc is 4201
sk->sk_refcnt is 2
sk->__sk_common.skc_cookie is 173585924
saddr daddr sport dport is 192.168.10.x 80

2. kprobe __sk_free
can not find the "saddr daddr sport dport 192.168.10.x 80" in kprobe __sk_f=
ree

3. kprobe __sk_free
after a while, "kprobe __sk_free" find the "saddr daddr sport dport
127.0.0.1 xx"' info
value =3D map2.find(sock*)
value1 =3D map1.find(sock->cookie)
if (value) {
    map2.delete(sock) //print value info, find "saddr daddr sport
dport" is "192.168.10.x 80=E2=80=9C=EF=BC=8C and value->cookie is 173585924=
, which is
the same as "192.168.10.x 80" 's cookie.
}

if (value1) {
    map1.delete(sock->cookie)
}

Here is my test flow, commented lines represents that  sock of =E2=80=9Dsad=
dr
daddr sport dport 192.168.10.x 80=E2=80=9C does not come in  __sk_free=EF=
=BC=8C but it
is reused by =E2=80=9D saddr daddr sport dport 127.0.0.1 xx"


mingkun bian <bianmingkun@gmail.com> =E4=BA=8E2022=E5=B9=B411=E6=9C=8812=E6=
=97=A5=E5=91=A8=E5=85=AD 17:01=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi,
>     I found a problem that a sock whose state is ESTABLISHED is not
> freed to slab cache by __sock_free.
>     The test scenario is as follows=EF=BC=9A
>
>     1. A HTTP Server=EF=BC=8CI insert a node to ebpf
> map(BPF_MAP_TYPE_LRU_HASH) by BPF_MAP_UPDATE_ELEM when receiving a
> "HTTP GET" request in user application.
>     ebpf map is=EF=BC=9A
>     key: cookie(getsockopt(fd, SOL_SOCKET, SO_COOKIE, &cookie, &optlen))
>     value: saddr sport daddr dport cookie...
>
>     2. I delete the corresponding ebpf map node by "kprobe __sk_free"
> in ebpf as following, bpf_map_delete_elem keeps returning 0.
>
>     SEC("kprobe/__sk_free")
>     int bpf_prog_destroy_sock(struct pt_regs *ctx)
>     {
>         struct sock *sk;
>         __u64 cookie;
>        struct  tcp_infos *value;
>
>        sk =3D (struct sock *) PT_REGS_PARM1(ctx);
>        bpf_probe_read(&cookie, sizeof(sk->__sk_common.skc_cookie),
> &sk->__sk_common.skc_cookie);
>        value =3D bpf_map_lookup_elem(&bpfmap, &cookie);
>        if (value) {
>            if (bpf_map_delete_elem(&bpfmap, &cookie) !=3D 0) {
>                debugmsg("delete failed\n");
>            }
>        }
>     }
>
>    3. Sending pressure "HTTP GET" requests to HTTP Server for a while,
>  then stop to send and close the HTTP Server, then wait a long time,
> we can not see any tcpinfo by "netstat -anp", then error occurs=EF=BC=9A
>     We can see some node which is not deleted int ebpf map by "bpftool
> map dump id **"=EF=BC=8C it seems like "sock leak", but the sockstat's
> inuse(cat /proc/net/sockstat) does not increase quickly.
>
> 4. I did some more experiments by ebpf kprobe, I find that a
> sock(state is ESTABLISHED, HTTP server recv a "HTTP GET" requset) does
> not come in __sock_free, but the same sock will be reused by another
> tcp connection(the most frequent is "127.0.0.1") after a while.
>    What I doubt is that why a new tcp connection can resue a old sock
> while the old sock does not come in __sk_free.
>
> Thanks.

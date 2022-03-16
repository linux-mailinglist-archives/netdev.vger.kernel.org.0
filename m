Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62EC04DA9A0
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 06:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353601AbiCPFZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 01:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239007AbiCPFZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 01:25:21 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A5347074;
        Tue, 15 Mar 2022 22:24:07 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id l18so1200241ioj.2;
        Tue, 15 Mar 2022 22:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=DMZ5PftV8DqRLo/y5qiKFG9FrFg2iKzN2l+qxxDoH0s=;
        b=IykPSqEE23eGzWLWCPSMSwWu+X8QOnNQyyXzLU+rEAy2swdo2XOo4N4sBF+7r409Ef
         O8NbCOGvxNuxwATlN5FpoZhP9LlP3FBBAPq5E+94AxKawq7SrLy2x7Pp4zpWerWcjAhW
         xZqWz3uhgRU/yfpKkfjUQ/oZUti9zGzi8GQaFDg5ATBdn3uXOnjkPjN5JRi0w5Q5Eg3Q
         /xfK5uCnrXW4nQ8gRO5kmyWEFIxD4G/VDbwOD4nxq/nF+idM0jx29o//hbthLSijPSXd
         h3lIwmdll3z2nkDH0YHza2NTDeKKQkSvtil4SNBfq3wP5RNw7Xxr1CGGHcrM3zSmnwzR
         E4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=DMZ5PftV8DqRLo/y5qiKFG9FrFg2iKzN2l+qxxDoH0s=;
        b=cnTsHI9LVaXRGeS5gleVtjfBvFKiMCNZgh80wZ0Gigp2f5l5xBTotfQtblYuhZIg0s
         xiE08D5d4YdarIUtLNEnEDxpt5SHqz1HkGD9sOn5B1+Li5szk1gpAThk9Y/Ydcszq7Xt
         caRjFCSsWWix3MuLlA4EPeVVhN12D6aP41RlVLuM7yD80o390Oml0uWb8YnNGyvVAso2
         8NveJBBiLBtMfkszMpZjtKTtnaGaBxzPOgDyp48F8DrAJ+2W2057Z/clxeYtB8cqIoE5
         o30agFONskU1xNiFjUss1JiMuZhE6Mo2ShTOj97vTOy+gHKrVuPTaY+Sdw9blO1i60EJ
         SEAQ==
X-Gm-Message-State: AOAM533IDhbvilit0RIInulM5fmgtSrGs0tkv82NRW+U79mMTLKdoDZR
        zaf6USjZNl5E9sRXDbWr0/M=
X-Google-Smtp-Source: ABdhPJzXonFhECtM8pmbNEiIfrjb0sg0qdhkfAqRYIAe4BfH0Jdb8uJCKysFkS5z1SZk7EiGAh6s9A==
X-Received: by 2002:a05:6638:408e:b0:319:b899:d1b9 with SMTP id m14-20020a056638408e00b00319b899d1b9mr23937379jam.221.1647408246974;
        Tue, 15 Mar 2022 22:24:06 -0700 (PDT)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id b24-20020a5d8d98000000b006409ad493fbsm512509ioj.21.2022.03.15.22.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 22:24:06 -0700 (PDT)
Date:   Tue, 15 Mar 2022 22:23:58 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     wangyufen <wangyufen@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, lmb@cloudflare.com,
        davem@davemloft.net, kafai@fb.com, dsahern@kernel.org,
        kuba@kernel.org, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <6231746e8e561_ad0208bf@john.notmuch>
In-Reply-To: <f5a45e95-bac2-e1be-2d7b-5e6d55f9b408@huawei.com>
References: <20220314124432.3050394-1-wangyufen@huawei.com>
 <87sfrky2bt.fsf@cloudflare.com>
 <ff9d0ecf-315b-00a3-8140-424714b204ff@huawei.com>
 <87fsnjxvho.fsf@cloudflare.com>
 <79281351-b412-2c54-265b-c0ddf537fae1@iogearbox.net>
 <f5a45e95-bac2-e1be-2d7b-5e6d55f9b408@huawei.com>
Subject: Re: [PATCH bpf-next] bpf, sockmap: Manual deletion of sockmap
 elements in user mode is not allowed
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wangyufen wrote:
> =

> =E5=9C=A8 2022/3/16 0:25, Daniel Borkmann =E5=86=99=E9=81=93:
> > On 3/15/22 1:12 PM, Jakub Sitnicki wrote:
> >> On Tue, Mar 15, 2022 at 03:24 PM +08, wangyufen wrote:
> >>> =E5=9C=A8 2022/3/14 23:30, Jakub Sitnicki =E5=86=99=E9=81=93:
> >>>> On Mon, Mar 14, 2022 at 08:44 PM +08, Wang Yufen wrote:
> >>>>> A tcp socket in a sockmap. If user invokes bpf_map_delete_elem to=
 =

> >>>>> delete
> >>>>> the sockmap element, the tcp socket will switch to use the TCP =

> >>>>> protocol
> >>>>> stack to send and receive packets. The switching process may caus=
e =

> >>>>> some
> >>>>> issues, such as if some msgs exist in the ingress queue and are =

> >>>>> cleared
> >>>>> by sk_psock_drop(), the packets are lost, and the tcp data is =

> >>>>> abnormal.
> >>>>>
> >>>>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> >>>>> ---
> >>>> Can you please tell us a bit more about the life-cycle of the =

> >>>> socket in
> >>>> your workload? Questions that come to mind:
> >>>>
> >>>> 1) What triggers the removal of the socket from sockmap in your ca=
se?
> >>> We use sk_msg to redirect with sock hash, like this:
> >>>
> >>> =C2=A0=C2=A0skA=C2=A0=C2=A0 redirect=C2=A0=C2=A0=C2=A0 skB
> >>> =C2=A0=C2=A0Tx <-----------> skB,Rx
> >>>
> >>> And construct a scenario where the packet sending speed is high, th=
e
> >>> packet receiving speed is slow, so the packets are stacked in the =

> >>> ingress
> >>> queue on the receiving side. In this case, if run =

> >>> bpf_map_delete_elem() to
> >>> delete the sockmap entry, will trigger the following procedure:
> >>>
> >>> sock_hash_delete_elem()
> >>> =C2=A0=C2=A0 sock_map_unref()
> >>> =C2=A0=C2=A0=C2=A0=C2=A0 sk_psock_put()
> >>> =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0 sk_psock_drop()
> >>> =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 sk_psock_stop()
> >>> =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 __sk_psock_zap_i=
ngress()
> >>> =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 __sk=
_psock_purge_ingress_msg()
> >>>
> >>>> 2) Would it still be a problem if removal from sockmap did not =

> >>>> cause any
> >>>> packets to get dropped?
> >>> Yes, it still be a problem. If removal from sockmap=C2=A0 did not c=
ause any
> >>> packets to get dropped, packet receiving process switches to use TC=
P
> >>> protocol stack. The packets in the psock ingress queue cannot be =

> >>> received
> >>>
> >>> by the user.
> >>
> >> Thanks for the context. So, if I understand correctly, you want to a=
void
> >> breaking the network pipe by updating the sockmap from user-space.
> >>
> >> This sounds awfully similar to BPF_MAP_FREEZE. Have you considered t=
hat?
> >
> > +1
> >
> > Aside from that, the patch as-is also fails BPF CI in a lot of places=
, =

> > please
> > make sure to check selftests:
> >
> > https://github.com/kernel-patches/bpf/runs/5537367301?check_suite_foc=
us=3Dtrue =

> >
> >
> > =C2=A0 [...]
> > =C2=A0 #145/73 sockmap_listen/sockmap IPv6 test_udp_redir:OK
> > =C2=A0 #145/74 sockmap_listen/sockmap IPv6 test_udp_unix_redir:OK
> > =C2=A0 #145/75 sockmap_listen/sockmap Unix test_unix_redir:OK
> > =C2=A0 #145/76 sockmap_listen/sockmap Unix test_unix_redir:OK
> > =C2=A0 ./test_progs:test_ops_cleanup:1424: map_delete: expected =

> > EINVAL/ENOENT: Operation not supported
> > =C2=A0 test_ops_cleanup:FAIL:1424
> > =C2=A0 ./test_progs:test_ops_cleanup:1424: map_delete: expected =

> > EINVAL/ENOENT: Operation not supported
> > =C2=A0 test_ops_cleanup:FAIL:1424
> > =C2=A0 #145/77 sockmap_listen/sockhash IPv4 TCP test_insert_invalid:F=
AIL
> > =C2=A0 ./test_progs:test_ops_cleanup:1424: map_delete: expected =

> > EINVAL/ENOENT: Operation not supported
> > =C2=A0 test_ops_cleanup:FAIL:1424
> > =C2=A0 ./test_progs:test_ops_cleanup:1424: map_delete: expected =

> > EINVAL/ENOENT: Operation not supported
> > =C2=A0 test_ops_cleanup:FAIL:1424
> > =C2=A0 #145/78 sockmap_listen/sockhash IPv4 TCP test_insert_opened:FA=
IL
> > =C2=A0 ./test_progs:test_ops_cleanup:1424: map_delete: expected =

> > EINVAL/ENOENT: Operation not supported
> > =C2=A0 test_ops_cleanup:FAIL:1424
> > =C2=A0 ./test_progs:test_ops_cleanup:1424: map_delete: expected =

> > EINVAL/ENOENT: Operation not supported
> > =C2=A0 test_ops_cleanup:FAIL:1424
> > =C2=A0 #145/79 sockmap_listen/sockhash IPv4 TCP test_insert_bound:FAI=
L
> > =C2=A0 ./test_progs:test_ops_cleanup:1424: map_delete: expected =

> > EINVAL/ENOENT: Operation not supported
> > =C2=A0 test_ops_cleanup:FAIL:1424
> > =C2=A0 ./test_progs:test_ops_cleanup:1424: map_delete: expected =

> > EINVAL/ENOENT: Operation not supported
> > =C2=A0 test_ops_cleanup:FAIL:1424
> > =C2=A0 [...]
> >
> > Thanks,
> > Daniel
> > .
> =

> I'm not sure about this patch. The main purpose is to point out the =

> possible problems
> =

> when the socket is deleted from the map.I'm sorry for the trouble.
> =

> Thanks.

If you want to delete a socket you should flush it first. To do this
stop redirecting traffic to it and then read all the data out. At
the moment its a bit tricky to know when the recieving socket is
empty though. Adding a flag on delete to only delete when the
ingress qlen =3D=3D 0 might be a possibility if you need delete to
work and are trying to work out how to safely delete sockets.=

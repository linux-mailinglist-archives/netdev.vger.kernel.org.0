Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B432E5FB478
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 16:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJKOXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 10:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJKOXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 10:23:22 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8952C925B4
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 07:23:21 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id r15-20020a4abf0f000000b004761c7e6be1so10125026oop.9
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 07:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tg0K9Lcf+BZPICr6ex5nQidf8aghcnapzzOiBAeExJg=;
        b=nln+qXLGxR3lmnbN2Bmne1jXzwr6q1J1MD/Xy+D3rOj4y+L5g9CGxDMDDfDG4QGkmu
         a6MZLfANf/LglLlylpBTv17zfPvogxOfPNmnvi9lxUnFVCxbZLhw9wOcbhtQlAGfMBzL
         QS6D1XEmp/td3+OyGDhQ81MXfYsfS83CovPA+QNBgM1Pcv6h7QpQM6SAwD2j4uYfQHms
         H1+sJuFeNQ2/KAvliAMEkNg8ARPBr41u4AL1C/laGGkg53/NRfK8hJfCCiT/Wm7IE8aO
         FYJV3OLW2LJuKBCC47Iw3pTzmH1u/AU6TdLiC0iBIvcidNND8djCsnDGV6stOwxcpCio
         LCwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tg0K9Lcf+BZPICr6ex5nQidf8aghcnapzzOiBAeExJg=;
        b=iNDSogiXUXIkrsGFI5OuYE2DUL8oUJGNyfz4CgaQ58jbUhgH+NdLDTxcFfME5GxPm+
         m7wArvCdRJ/J7eLSP7k4JvMk416MtfRs3UbATY6J36JzCR9hTLrxVKoIOcs2bAAZk3BG
         0UfXBqvaQP5KQScD1Zcb5WMDy0ym7OEIUv5bC1kBMMP3sef2IY/y5WfMsdx04/OMNQgs
         rZBIZAXZFuEHXaxoCv7R5Ibyy+PiFLoha1bUyvWZTIcpDoe2YyKI5GEk2v22QD6Xf55w
         3T0rr3T/Poa7HmuAEnGR+iepsj3dJvfymxWFbIniOe5glmwtFwDu/ZIEnF52/u+1S8KN
         6/ZA==
X-Gm-Message-State: ACrzQf2MZCZ38zjKaD6Nctf/rrVCPe8OwmXCuPq6oFbj6awa++qrPyYB
        zL9zhArqkg5HdY8kCxFXDzT+q6uVbyVoKPcZ30Y=
X-Google-Smtp-Source: AMsMyM7T8HoexPYdRZHg8NTWp6tm678tYJ86lZ2zhcDDJ+2VJN6p5ATY9zJ7nHg2tTObTH3DGzcii4TJ3sf+iLk6K/E=
X-Received: by 2002:a05:6830:4101:b0:659:d456:71f9 with SMTP id
 w1-20020a056830410100b00659d45671f9mr10263652ott.295.1665498200807; Tue, 11
 Oct 2022 07:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <c5c9092a22a2194650222bffaf786902613deb16.1665085502.git.lucien.xin@gmail.com>
 <f7tczayh47y.fsf@redhat.com> <f7t8rlmh2us.fsf@redhat.com>
In-Reply-To: <f7t8rlmh2us.fsf@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 11 Oct 2022 10:22:30 -0400
Message-ID: <CADvbK_eDC8KGVZwQPGtEyWovBAqoMEHR15DCiGzL-u5ivigPMw@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net] openvswitch: add nf_ct_is_confirmed check
 before assigning the helper
To:     Aaron Conole <aconole@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        Florian Westphal <fw@strlen.de>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eric Dumazet <edumazet@google.com>, kuba@kernel.org,
        Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 11, 2022 at 10:06 AM Aaron Conole <aconole@redhat.com> wrote:
>
> Aaron Conole <aconole@redhat.com> writes:
>
> > Xin Long <lucien.xin@gmail.com> writes:
> >
> >> A WARN_ON call trace would be triggered when 'ct(commit, alg=helper)'
> >> applies on a confirmed connection:
> >>
> >>   WARNING: CPU: 0 PID: 1251 at net/netfilter/nf_conntrack_extend.c:98
> >>   RIP: 0010:nf_ct_ext_add+0x12d/0x150 [nf_conntrack]
> >>   Call Trace:
> >>    <TASK>
> >>    nf_ct_helper_ext_add+0x12/0x60 [nf_conntrack]
> >>    __nf_ct_try_assign_helper+0xc4/0x160 [nf_conntrack]
> >>    __ovs_ct_lookup+0x72e/0x780 [openvswitch]
> >>    ovs_ct_execute+0x1d8/0x920 [openvswitch]
> >>    do_execute_actions+0x4e6/0xb60 [openvswitch]
> >>    ovs_execute_actions+0x60/0x140 [openvswitch]
> >>    ovs_packet_cmd_execute+0x2ad/0x310 [openvswitch]
> >>    genl_family_rcv_msg_doit.isra.15+0x113/0x150
> >>    genl_rcv_msg+0xef/0x1f0
> >>
> >> which can be reproduced with these OVS flows:
> >>
> >>   table=0, in_port=veth1,tcp,tcp_dst=2121,ct_state=-trk
> >>   actions=ct(commit, table=1)
> >>   table=1, in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+new
> >>   actions=ct(commit, alg=ftp),normal
> >>
> >> The issue was introduced by commit 248d45f1e193 ("openvswitch: Allow
> >> attaching helper in later commit") where it somehow removed the check
> >> of nf_ct_is_confirmed before asigning the helper. This patch is to fix
> >> it by bringing it back.
> >>
> >> Fixes: 248d45f1e193 ("openvswitch: Allow attaching helper in later commit")
> >> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> >> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >> ---
> >
> > Hi Xin,
> >
> > Looking at the original commit, I think this will read like a revert.  I
> > am doing some testing now, but I think we need input from Yi-Hung to
> > find out what the use case is that the original fixed.
>
> I'm also not able to reproduce the WARN_ON.  My env:
>
> kernel: 4c86114194e6 ("Merge tag 'iomap-6.1-merge-1' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux")
>
> Using current upstream OVS
> I used your flows (adjusting the port names):
>
>  cookie=0x0, duration=246.240s, table=0, n_packets=17, n_bytes=1130, ct_state=-trk,tcp,in_port=v0,tp_dst=2121 actions=ct(commit,table=1)
>  cookie=0x0, duration=246.240s, table=1, n_packets=1, n_bytes=74, ct_state=+new+trk,tcp,in_port=v0,tp_dst=2121 actions=ct(commit,alg=ftp),NORMAL
>
> and ran:
>
> $ ip netns exec server python3 -m pyftpdlib -i 172.31.110.20 &
> $ ip netns exec client curl ftp://172.31.110.20:2121
>
> but no WARN_ON message got triggered.  Are there additional flows you
> used that I am missing, or perhaps this should be on a different kernel
> commit?
>
> > -Aaron
>
Hi, Aaron, thanks for looking at this.

Here is a script to reproduce it, you can try, and let me know if it's
still not reproduced
(it's also upstream ovs, for the first 2 lines, you may adjust on your env.)

export PATH=$PATH:/usr/local/share/openvswitch/scripts
ovs-ctl restart #systemctl restart openvswitch

ip net add ns0
ip net add ns1
ip link add veth0 type veth peer name veth1
ip link add veth3 type veth peer name veth2
ip link set veth0 netns ns0
ip link set veth3 netns ns1
ip net exec ns0 ip addr add  7.7.7.1/24 dev veth0
mac1=`ip net exec ns1 cat /sys/class/net/veth3/address`
mac2=`ip net exec ns0 cat /sys/class/net/veth0/address`
ip net exec ns0 ip neigh add 7.7.16.2 dev veth0 lladdr $mac1
ip net exec ns1 ip addr add  7.7.16.2/24 dev veth3
ip net exec ns1 ip neigh add 7.7.16.1 dev veth3 lladdr $mac2
ip net exec ns0 ip link set veth0 up
ip net exec ns1 ip link set veth3 up
ip net exec ns0 ip route add  7.7.16.2 dev veth0

sleep 0.5
ovs-vsctl set Open_vSwitch . other_config:hw-offload=false
ovs-vsctl set Open_vSwitch . other_config:tc-policy=skip_hw
ovs-vsctl add-br br-ovs
ovs-vsctl add-port br-ovs veth1
ovs-vsctl add-port br-ovs veth2
ip link set br-ovs up
ip link set veth1 up
ip link set veth2 up

ovs-ofctl del-flows br-ovs
ovs-ofctl add-flow br-ovs arp,actions=normal
ovs-ofctl add-flow br-ovs icmp,actions=normal
ovs-ofctl add-flow br-ovs "table=0,
in_port=veth1,tcp,tcp_dst=2121,ct_state=-trk actions=ct(commit,
table=1)"
#ovs-ofctl add-flow br-ovs "table=0,
in_port=veth1,tcp,tcp_dst=2121,ct_state=-trk actions=ct(table=1, nat)"
ovs-ofctl add-flow br-ovs "table=0, in_port=veth2,tcp,ct_state=-trk
actions=ct(table=1, nat)"
ovs-ofctl add-flow br-ovs "table=0, in_port=veth1,tcp,ct_state=-trk
actions=ct(table=0, nat)"

ovs-ofctl add-flow br-ovs "table=0,
in_port=veth1,tcp,ct_state=+trk+rel actions=ct(commit, nat),normal"
ovs-ofctl add-flow br-ovs "table=0,
in_port=veth1,tcp,ct_state=+trk+est actions=veth2"

ovs-ofctl add-flow br-ovs "table=1,
in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+new actions=ct(commit)"
ovs-ofctl add-flow br-ovs "table=1,
in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+new actions=ct(commit,
alg=ftp),normal"

ovs-ofctl add-flow br-ovs "table=1,
in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+new actions=ct(commit,
nat(src=7.7.16.1), alg=ftp),normal"
ovs-ofctl add-flow br-ovs "table=1,
in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+est actions=veth2"
ovs-ofctl add-flow br-ovs "table=1,
in_port=veth2,tcp,ct_state=+trk+est actions=veth1"
ovs-ofctl dump-flows br-ovs --color
conntrack -F

ip netns exec ns1 echo "test" > a
ip netns exec ns1 python3 -m pyftpdlib -p 2121 -D &
sleep 2
ip netns exec ns0 wget ftp://anonymous@7.7.16.2:2121/a

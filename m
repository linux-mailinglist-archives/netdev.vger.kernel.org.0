Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FA9656401
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 17:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiLZQDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 11:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLZQDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 11:03:50 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49262ADB
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 08:03:46 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id j206so12030209ybj.1
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 08:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4WBfGJR+rhhek1OzxsO7eZChkwh59QoJ7t0kvUo1Z98=;
        b=iohADgP+p+c2d//Pwt2hBg+ZxyZxBIxNQPx43XA0+shI/y2YsCo0PsQlbIMhHd1MXh
         RhaV9tJUU3bugv4IolOMKFJQ2yzHoJaXlg2I8pjlpDgec6xN6OeqmrYxij2oVy4E+utq
         nJSRepTr/jXJokLb1QeRrfoOxQfvdROFV4fwxbb8rZ4l1HXxBxgmNWxbCuqYDIZY17TW
         wEk+V7zyNdXsWI5qD76dSSUNhP73ICRje9JwF2d2nqnezajw5WeYmy/ENzAYBEznJIY1
         6ehed5fnQRHUTKxrpXSU8GtXTEAAEBgU5YNAs0LLhLX19149wjOyJjlWy8nq9c3ZGjAf
         crlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4WBfGJR+rhhek1OzxsO7eZChkwh59QoJ7t0kvUo1Z98=;
        b=fliVgM/iu9EI6zSZiAZ3TikmjMdVSudVuSMGMDT3H6fpbAwQ6Pgt1CtCHDc3A4J9fT
         DpgqAoNVgoHr7CmBkUay16VfIOOaMvt73fL0tu7c8xph3GQ2MB3C8f/jVyzznepJ84uI
         6qjxv8Jt6iO1fsylSfwvV4unCUjYaU1ejYwrVn/ZdUCdDKnNDX96SBOJBZYKJbp1p00v
         UNG3jkzAaVD3KL2cXPwZEJUYlDU3LswCJxzyf3co8BURdxBgCVy2kbenDyTRMRxvmFhI
         5RdxBSUJIs6cnVORN8ddtBdJva6RnP/0aKjB8lJ9WPbf1T5PKPYkC9EuXCbDMsjPr1iT
         +ZOA==
X-Gm-Message-State: AFqh2kp06OogAObuHNe2k40XrBzbMzdepJZoFuG4y0rdxGp9PyLSHguH
        d6nXVdNGEAZJT+EWA2D2vR3kz01/HQDSgDfBvbNoXw==
X-Google-Smtp-Source: AMrXdXtIMGtRNGHF74Zs9WxXEpsg9cpsr/zZv3WglgBjhduA2J+EUvUuwenBMewSAR5C91aMWdYp9EAAzr8zGHSR2v0=
X-Received: by 2002:a25:34cd:0:b0:709:e347:747b with SMTP id
 b196-20020a2534cd000000b00709e347747bmr2208372yba.188.1672070625950; Mon, 26
 Dec 2022 08:03:45 -0800 (PST)
MIME-Version: 1.0
References: <ae44a3c9e42476d3a0f6edd87873fbea70b520bf.1671560567.git.dcaratti@redhat.com>
 <840dbfccffa9411a5e0f804885cbb7df66a22e78.1671560567.git.dcaratti@redhat.com>
In-Reply-To: <840dbfccffa9411a5e0f804885cbb7df66a22e78.1671560567.git.dcaratti@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 26 Dec 2022 11:03:34 -0500
Message-ID: <CAM0EoMnJeb3QsfxgsggEMjTACdu0hq6mb3O+uGOfVzG2RZ-hkw@mail.gmail.com>
Subject: Re: [RFC net-next 2/2] act_mirred: use the backlog for nested calls
 to mirred ingress
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us,
        marcelo.leitner@gmail.com, pabeni@redhat.com, wizhao@redhat.com,
        xiyou.wangcong@gmail.com, lucien.xin@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Davide,
So this would fix the false positive you are seeing i believe;
however, will it fix a real loop?
In particular I am not sure if the next packet grabbed from the
backlog will end up in the
same CPU.

cheers,
jamal

On Tue, Dec 20, 2022 at 1:25 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> William reports kernel soft-lockups on some OVS topologies when TC mirred
> egress->ingress action is hit by local TCP traffic [1].
> The same can also be reproduced with SCTP (thanks Xin for verifying), when
> client and server reach themselves through mirred egress to ingress, and
> one of the two peers sends a "heartbeat" packet (from within a timer).
>
> Enqueueing to backlog proved to fix this soft lockup; however, as Cong
> noticed [2], we should preserve - when possible - the current mirred
> behavior that counts as "overlimits" any eventual packet drop subsequent to
> the mirred forwarding action [3]. A compromise solution might use the
> backlog only when tcf_mirred_act() has a nest level greater than one:
> change tcf_mirred_forward() accordingly.
>
> Also, add a kselftest that can reproduce the lockup and verifies TC mirred
> ability to account for further packet drops after TC mirred egress->ingress
> (when the nest level is 1).
>
>  [1] https://lore.kernel.org/netdev/33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com/
>  [2] https://lore.kernel.org/netdev/Y0w%2FWWY60gqrtGLp@pop-os.localdomain/
>  [3] such behavior is not guaranteed: for example, if RPS or skb RX
>      timestamping is enabled on the mirred target device, the kernel
>      can defer receiving the skb and return NET_RX_SUCCESS inside
>      tcf_mirred_forward().
>
> Reported-by: William Zhao <wizhao@redhat.com>
> CC: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  net/sched/act_mirred.c                        |  7 +++
>  .../selftests/net/forwarding/tc_actions.sh    | 49 ++++++++++++++++++-
>  2 files changed, 55 insertions(+), 1 deletion(-)
>
> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> index c8abb5136491..8037ec9b1d31 100644
> --- a/net/sched/act_mirred.c
> +++ b/net/sched/act_mirred.c
> @@ -206,12 +206,19 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
>         return err;
>  }
>
> +static bool is_mirred_nested(void)
> +{
> +       return unlikely(__this_cpu_read(mirred_nest_level) > 1);
> +}
> +
>  static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
>  {
>         int err;
>
>         if (!want_ingress)
>                 err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
> +       else if (is_mirred_nested())
> +               err = netif_rx(skb);
>         else
>                 err = netif_receive_skb(skb);
>
> diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
> index 1e0a62f638fe..919c0dd9fe4b 100755
> --- a/tools/testing/selftests/net/forwarding/tc_actions.sh
> +++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
> @@ -3,7 +3,8 @@
>
>  ALL_TESTS="gact_drop_and_ok_test mirred_egress_redirect_test \
>         mirred_egress_mirror_test matchall_mirred_egress_mirror_test \
> -       gact_trap_test mirred_egress_to_ingress_test"
> +       gact_trap_test mirred_egress_to_ingress_test \
> +       mirred_egress_to_ingress_tcp_test"
>  NUM_NETIFS=4
>  source tc_common.sh
>  source lib.sh
> @@ -198,6 +199,52 @@ mirred_egress_to_ingress_test()
>         log_test "mirred_egress_to_ingress ($tcflags)"
>  }
>
> +mirred_egress_to_ingress_tcp_test()
> +{
> +       local tmpfile=$(mktemp) tmpfile1=$(mktemp)
> +
> +       RET=0
> +       dd conv=sparse status=none if=/dev/zero bs=1M count=2 of=$tmpfile
> +       tc filter add dev $h1 protocol ip pref 100 handle 100 egress flower \
> +               $tcflags ip_proto tcp src_ip 192.0.2.1 dst_ip 192.0.2.2 \
> +                       action ct commit nat src addr 192.0.2.2 pipe \
> +                       action ct clear pipe \
> +                       action ct commit nat dst addr 192.0.2.1 pipe \
> +                       action ct clear pipe \
> +                       action skbedit ptype host pipe \
> +                       action mirred ingress redirect dev $h1
> +       tc filter add dev $h1 protocol ip pref 101 handle 101 egress flower \
> +               $tcflags ip_proto icmp \
> +                       action mirred ingress redirect dev $h1
> +       tc filter add dev $h1 protocol ip pref 102 handle 102 ingress flower \
> +               ip_proto icmp \
> +                       action drop
> +
> +       ip vrf exec v$h1 nc --recv-only -w10 -l -p 12345 -o $tmpfile1  &
> +       local rpid=$!
> +       ip vrf exec v$h1 nc -w1 --send-only 192.0.2.2 12345 <$tmpfile
> +       wait -n $rpid
> +       cmp -s $tmpfile $tmpfile1
> +       check_err $? "server output check failed"
> +
> +       $MZ $h1 -c 10 -p 64 -a $h1mac -b $h1mac -A 192.0.2.1 -B 192.0.2.1 \
> +               -t icmp "ping,id=42,seq=5" -q
> +       tc_check_packets "dev $h1 egress" 101 10
> +       check_err $? "didn't mirred redirect ICMP"
> +       tc_check_packets "dev $h1 ingress" 102 10
> +       check_err $? "didn't drop mirred ICMP"
> +       local overlimits=$(tc_rule_stats_get ${h1} 101 egress .overlimits)
> +       test ${overlimits} = 10
> +       check_err $? "wrong overlimits, expected 10 got ${overlimits}"
> +
> +       tc filter del dev $h1 egress protocol ip pref 100 handle 100 flower
> +       tc filter del dev $h1 egress protocol ip pref 101 handle 101 flower
> +       tc filter del dev $h1 ingress protocol ip pref 102 handle 102 flower
> +
> +       rm -f $tmpfile $tmpfile1
> +       log_test "mirred_egress_to_ingress_tcp ($tcflags)"
> +}
> +
>  setup_prepare()
>  {
>         h1=${NETIFS[p1]}
> --
> 2.38.1
>

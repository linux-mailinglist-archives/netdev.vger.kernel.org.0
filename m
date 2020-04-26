Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3EC1B9305
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 20:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgDZSip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 14:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726165AbgDZSip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 14:38:45 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3383C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 11:38:44 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n4so12144650ejs.11
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 11:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v2wZeY20fxq9CdEKJnefHSsSlf1AI6qACEvW5aOV4yU=;
        b=S7bIbkThluoCUAhsAHHZvCzQ4P4Txi6IqLIcZ6/qnSMjuxN37yob25TCHW7Fyhkanx
         q5QNK3pjKi3+jfGLPkr0Az4d2pB5xL5EXEitEjJvBK6j0/3Db/V2d8z9u1niyPS1B6su
         7euoT+r6F4igNUk/TuwclPgmnoMFsLPY/Vczc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v2wZeY20fxq9CdEKJnefHSsSlf1AI6qACEvW5aOV4yU=;
        b=GrQCGLWBwCE5leCLQFlw9fA56OXqG/VQteS7/aNybR5XdVSB+HsHB1t/5tLLn0h+sa
         crkY1RvtwkDyiloFPEPwl9eYwXEZhxltFMxIrtaE8WmbDluS+//cPacNL2nZJEbmpflZ
         XKmkvOU17n3zckjODWurV2yqVg8svJQm6TkcFllrFbntDG5MnEMQmMbnEsorxXDdGyfv
         JE14A2I2F+YyFCflKWW4mCO203JstWrQbxkqiarQNs/k4ngwt4MPSgWU0dhi1wa19JqL
         BJdkfLzczWPSTUoL1qREeByzbziaVihEMIYQHholCWYIWDuF6j1UznTm4omOwx08e3MU
         /1Jw==
X-Gm-Message-State: AGi0PuYS0GBpdBJeg9D+fYlUaYk3p3aFF3AFXfeYRFu5de42IqpX/yHl
        FkKx9+oLzwqiM/IM7RB3aOQbjumNn4cZj07ZaiVjHg==
X-Google-Smtp-Source: APiQypLm+fxyupZvMWk90JNbAPVVs0arc1sQ0GCTRBFHhnreBAf53GYhIffVaPkVeB7jZvWR6bjkfDyqC8AMAIbSw50=
X-Received: by 2002:a17:906:ce49:: with SMTP id se9mr13251974ejb.345.1587926322503;
 Sun, 26 Apr 2020 11:38:42 -0700 (PDT)
MIME-Version: 1.0
References: <1587862128-24319-1-git-send-email-roopa@cumulusnetworks.com>
 <1587862128-24319-4-git-send-email-roopa@cumulusnetworks.com> <fd7e0fa8-dc1b-b410-a327-f09cbe929c82@gmail.com>
In-Reply-To: <fd7e0fa8-dc1b-b410-a327-f09cbe929c82@gmail.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Sun, 26 Apr 2020 11:38:31 -0700
Message-ID: <CAJieiUhpM7r0Ly4WUqvCJm34LUjuj=Mo5V9JiWrVTd=nLiAMHQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] selftests: net: add new testcases for
 nexthop API compat mode sysctl
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Benjamin Poirier <bpoirier@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 10:40 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 4/25/20 6:48 PM, Roopa Prabhu wrote:
> > @@ -253,6 +253,33 @@ check_route6()
> >       check_output "${out}" "${expected}"
> >  }
> >
> > +start_ip_monitor()
> > +{
> > +     local mtype=$1
> > +
> > +     # start the monitor in the background
> > +     tmpfile=`mktemp /var/run/nexthoptestXXX`
> > +     mpid=`($IP monitor $1 > $tmpfile & echo $!) 2>/dev/null`
>
> && echo?
>
> also, that looks weird. shouldn't it be:
>         mpid=($IP monitor ${mtype} > $tmpfile 2>&1 && echo $!)
>

no, the & is for background. I picked this from the rtnetlink selftest.
It can be moved to a library if there is one, this version is
specifically for route monitor.

> you declare mtype but use $1.

will fix , thats a leftover from last min cleanup

>
>
> > +     sleep 0.2
> > +     echo "$mpid $tmpfile"
> > +}
> > +
> > +stop_ip_monitor()
> > +{
> > +     local mpid=$1
> > +     local tmpfile=$2
> > +     local el=$3
> > +
> > +     # check the monitor results
> > +     kill $mpid
> > +     lines=`wc -l $tmpfile | cut "-d " -f1`
>
> just for consistency with the rest of the script, use $(...) instead of
> `...`
>
> > +     test $lines -eq $el
> > +     rc=$?
> > +     rm -rf $tmpfile
> > +
> > +     return $rc
> > +}
> > +
> >  ################################################################################
> >  # basic operations (add, delete, replace) on nexthops and nexthop groups
> >  #
>
> ...
>
> > +ipv6_compat_mode()
> > +{
> > +     local rc
> > +
> > +     echo
> > +     echo "IPv6 nexthop api compat mode test"
> > +     echo "--------------------------------"
> > +
> > +     sysctl_nexthop_compat_mode_check "IPv6"
> > +     if [ $? -eq $ksft_skip ]; then
> > +             return $ksft_skip
> > +     fi
> > +
> > +     run_cmd "$IP nexthop add id 62 via 2001:db8:91::2 dev veth1"
> > +     run_cmd "$IP nexthop add id 63 via 2001:db8:91::3 dev veth1"
> > +     run_cmd "$IP nexthop add id 122 group 62/63"
> > +     ipmout=$(start_ip_monitor route)
> > +
> > +     run_cmd "$IP -6 ro add 2001:db8:101::1/128 nhid 122"
> > +     # route add notification should contain expanded nexthops
> > +     stop_ip_monitor $ipmout 3
> > +     log_test $? 0 "IPv6 compat mode on - route add notification"
> > +
> > +     # route dump should contain expanded nexthops
> > +     check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 122 metric 1024 pref medium nexthop via 2001:db8:91::2 dev veth1 weight 1 nexthop via 2001:db8:91::3 dev veth1 weight 1"
> > +     log_test $? 0 "IPv6 compat mode on - route dump"
> > +
> > +     # change in nexthop group should generate route notification
> > +     run_cmd "$IP nexthop add id 64 via 2001:db8:91::4 dev veth1"
> > +     ipmout=$(start_ip_monitor route)
> > +     run_cmd "$IP nexthop replace id 122 group 62/64"
> > +     stop_ip_monitor $ipmout 3
> > +
> > +     log_test $? 0 "IPv6 compat mode on - nexthop change"
> > +
> > +     # set compat mode off
> > +     sysctl_nexthop_compat_mode_set 0 "IPv6"
> > +
> > +     run_cmd "$IP -6 ro del 2001:db8:101::1/128 nhid 122"
> > +
> > +     run_cmd "$IP nexthop add id 62 via 2001:db8:91::2 dev veth1"
> > +     run_cmd "$IP nexthop add id 63 via 2001:db8:91::3 dev veth1"
> > +     run_cmd "$IP nexthop add id 122 group 62/63"
> > +     ipmout=$(start_ip_monitor route)
> > +
> > +     run_cmd "$IP -6 ro add 2001:db8:101::1/128 nhid 122"
> > +     # route add notification should not contain expanded nexthops
> > +     stop_ip_monitor $ipmout 1
> > +     log_test $? 0 "IPv6 compat mode off - route add notification"
> > +
> > +     # route dump should not contain expanded nexthops
> > +     check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 122 metric 1024 pref medium"
>
> here and above, remove the 'pref medium' from the string; it was moved
> by a recent iproute2 change (from Donald) so for compat with old and new
> iproute2 just drop it. See 493f3cc7ee02.
>

ack, looks like my iproute2 is a little old

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D30FDE90
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 14:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfKONIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 08:08:31 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20138 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727272AbfKONIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 08:08:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573823309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KW+xlZ6QqPnF9SFtAP1nA7oVn9LBMs9V9zow8jCuZq4=;
        b=HEyvZBgYkfkHS+bNcqfIjhRIizKULkF/tvBSv3/4/RdfiUI7waThOiGiNFYM6d5Q6ce0AA
        4yKfhuI1y3lsReF8c8SiLFQX4hYs9JBaaokqWuhFQk8Nn0cGnqDViUGHCY94OcVhvHO1g5
        JC0x7EKXgP+o6dSLssMX3qxrfFWOa4A=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-I5lE2NDINvy9Xycg4Zl6Zg-1; Fri, 15 Nov 2019 08:08:28 -0500
Received: by mail-lj1-f197.google.com with SMTP id r29so1530624ljd.1
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 05:08:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=KW+xlZ6QqPnF9SFtAP1nA7oVn9LBMs9V9zow8jCuZq4=;
        b=REuu721In+PiqkbJXEdrSOAzXqJFYb5xUddLFLq3zFxlYN0Tn14CkJK+k48x/5CqQA
         mnCaNj/+SIwdDk7HkHXgMAOzISIhFIBoIcDm27GcSCXcS/KzHcfDpkMKFXTq61eTIwbt
         eEMi86qLz5aEFVMCggEsR3T0tqi7oqzbzBdkS8rVP7zVJfzni7T8VpJ3iQJGMKNP4uoh
         C/zhNmcQe4gkbgMTI15HfE5TUl8qeY/fvRz3JOwxadRABUMrZ3XS8R7xXKbenBEvvIuT
         s/+Uh3LwtjMNLonkVel0JhbksCFWGU4Bm5bPEpHCsUPBiUMBX+0JZYYhlzLsK4sY2Uns
         FiWg==
X-Gm-Message-State: APjAAAUUiwwySk8oh7GNVD48XFyN7co3teyMvP0TqNuDhP+HZEAUovWA
        NRYeLL41rleZa/FCdLc3SC9m2MLeixZ9pu/JAcpDif6/rQD5Qmk0/rOCMz/e++0P1HTv60bJWCi
        a+F6F3mkL8/i3OtT+
X-Received: by 2002:a2e:89c6:: with SMTP id c6mr11119759ljk.113.1573823307363;
        Fri, 15 Nov 2019 05:08:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqxI8DX59s339AnvIwBuBVsMr4K/TAtr4akIkMiTg5sDXZ5phUu2Uclj3KqPEczIcx1goPPiyw==
X-Received: by 2002:a2e:89c6:: with SMTP id c6mr11119737ljk.113.1573823307169;
        Fri, 15 Nov 2019 05:08:27 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id v203sm4433066lfa.25.2019.11.15.05.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 05:08:26 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9083F1818C5; Fri, 15 Nov 2019 14:08:25 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jiri Benc <jbenc@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCH bpf] selftests: bpf: xdping is not meant to be run standalone
In-Reply-To: <4365c81198f62521344c2215909634407184387e.1573821726.git.jbenc@redhat.com>
References: <4365c81198f62521344c2215909634407184387e.1573821726.git.jbenc@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 15 Nov 2019 14:08:25 +0100
Message-ID: <87a78xmgmu.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: I5lE2NDINvy9Xycg4Zl6Zg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Benc <jbenc@redhat.com> writes:

> The actual test to run is test_xdping.sh, which is already in TEST_PROGS.
> The xdping program alone is not runnable with 'make run_tests', it
> immediatelly fails due to missing arguments.
>
> Move xdping to TEST_GEN_PROGS_EXTENDED in order to be built but not run.
>
> Fixes: cd5385029f1d ("selftests/bpf: measure RTT from xdp using xdping")
> Cc: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: Jiri Benc <jbenc@redhat.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>


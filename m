Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8299A138
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393177AbfHVUeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:34:07 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46473 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388297AbfHVUeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 16:34:07 -0400
Received: by mail-io1-f65.google.com with SMTP id x4so14715277iog.13;
        Thu, 22 Aug 2019 13:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/FTulEvcsnZLRIJmi7a8Mdwrg03XUfOFFyTuD5zY9FM=;
        b=vKUmNCKTue8s/CxYkoRN6Og3RHlNelmXURcTgXf+AbQ7Vzi+sRccdpG/33PnqrETMv
         k2BkaBpJdh2op5dsq//RsDIhD3MrCQg27tbWOrBjmWZWG3pphJsrJsyLfjkJ4Jzl4k+U
         LtO7TswTJW59N95GvnxY5/bkOzvfX4gjfET4DHhGaPnOfsRm6PQ5MD7GalVw3VsBqMYn
         LJK80RdOQAWHW4X7vHqWKZVMz0MjrMjAwvS4cikWXVRIP+zsMd7+CzjmMlpdhUq/G4Qp
         X63s+lu8kxFd88mTHEJrfw0wntcczswYZQXPvWL4/F/TnJ4ajk5hy6jmx9JwmmfocWm6
         OVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/FTulEvcsnZLRIJmi7a8Mdwrg03XUfOFFyTuD5zY9FM=;
        b=dkwY4Yr+3J5svR0vwwH43zjx5fRWMd8Hta3f/VcyzFneSQ94qC2lBmRjagS9TuISfP
         jkhswpTCyOKfL3q2H35el+tGYTFQ0hHuIJtnXDRIS6XH74ENGdRjWezPsDyljT337+1n
         n4ioK+486+Ayt5RGY4e7zmAwqjs5hoyMvyuJ33FpoZbb9zdWy/vgzyQn1SVzwTSOWUez
         nIYjeoMGdupTR3N5ZM/0nskU1EOPJY8eJLKfM+9Pc/HwSb8lPrHGhbfeaErC9X9y51Qj
         ATBWjffS7C8f3R/5q7TS9vdMJsPM7eo/YpNRMVfmikrLDumrKZt4fpM29wGl2caXv/t5
         cNiQ==
X-Gm-Message-State: APjAAAUclWCPKzDucCtf3KOfYGpLtkjT8IRvxztdFe464ZkHGEdYy1yk
        9ZBj2bMc4OnWn11SeIqfGfSIdzZoEtHwJN3deLQ=
X-Google-Smtp-Source: APXvYqzaM90LaKIlWUCqCFvD5hrgz/BA38zyAOawbdoEGYOoaKB+ToJwkrTl2nMFI1pf4q4gb9xJCWxu+P84PWaYtuE=
X-Received: by 2002:a5e:8344:: with SMTP id y4mr1903385iom.213.1566506046286;
 Thu, 22 Aug 2019 13:34:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190822080045.27609-1-olivier.tilmans@nokia-bell-labs.com>
In-Reply-To: <20190822080045.27609-1-olivier.tilmans@nokia-bell-labs.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 22 Aug 2019 13:33:55 -0700
Message-ID: <CAA93jw5_LN_-zhHh=zZA8r6Zvv1CvA_AikT_rCgWyT8ytQM_rg@mail.gmail.com>
Subject: Re: [PATCH net-next v5] sched: Add dualpi2 qdisc
To:     "Tilmans, Olivier (Nokia - BE/Antwerp)" 
        <olivier.tilmans@nokia-bell-labs.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Olga Albisser <olga@albisser.org>,
        "De Schepper, Koen (Nokia - BE/Antwerp)" 
        <koen.de_schepper@nokia-bell-labs.com>,
        Bob Briscoe <research@bobbriscoe.net>,
        Henrik Steen <henrist@henrist.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is vastly improved code, thank you!

1) Since we're still duking it out over the meaning of the bits - not
just the SCE thing, but as best as I can
tell (but could be wrong) the NQB idea wants to put something into the
l4s fast queue? Or is NQB supposed to
be a third queue?

In those cases, the ecn_mask should just be mask.

2) Is the intent to make the drop probability 0 by default? (10 in the
pie rfc, not mentioned in the l4s rfc as yet)

3) has this been tested on a hw mq system as yet? (10gigE is typically
64 queues)

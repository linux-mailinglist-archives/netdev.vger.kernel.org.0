Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C4DCCAD4
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 17:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbfJEPgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 11:36:07 -0400
Received: from mout.web.de ([212.227.15.14]:34547 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfJEPgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 11:36:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1570289750;
        bh=581eRY+k+CxI3cloKLyKONCxIwSbwThOFQSHQ+hY0IY=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=eOL9ZUSVP/2EME0uoFJ17CzQMUhY/8i+3Y3XZA1VzmgAcvl3IlVZ32P8VP56z0454
         PSSgZn7OX78Ok8NF2XZNwEboYF081THWym9/umaaYospLUiQzfZFD+Vdmc7Q3mN+20
         WvsGhHlvbUmmt8ugIfY/bm2LDNLi/w+1OQ+NZns0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.178.111]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LZet2-1hp6KH37i0-00lSCe; Sat, 05
 Oct 2019 17:35:49 +0200
Cc:     Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20191004194220.19412-1-navid.emamdoost@gmail.com>
Subject: Re: [PATCH] nl80211: fix memory leak in
 nl80211_get_ftm_responder_stats
To:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <dc0edb88-457f-fde8-4d91-d5b3b94bfb6d@web.de>
Date:   Sat, 5 Oct 2019 17:35:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191004194220.19412-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:uMcDUnE7oPU+Igw2DRU3WfuhKqttw0gQAl2Q0UV/G7QqrDMFJb8
 tug+60p+RaBbbf3tuGg+qK65gIbttuhv+Ee6Sk3k2lUsHMBTnpVqK5FXe0Y/DaMQos5EDwZ
 +kw5DzWBc95E68bAqa8s+VDxgw0cei0bvfjFGfbDf7iGApCRBY2Yl3PwgspfDRm9XtP62+i
 YyO3oRReZ+vDrICj532Qg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4JWz1KDunjk=:W+D9cB5gWs6HI5aEm/DeY/
 gm9pBjIbEixnbuypAt4CoDXxg+JRMfvBXdUPaZ5UP5+B5OHbURjThMTQvlHFK76s9cXBBqkT4
 6gC49ivL35sf4G1uoaxU7zVMKbhbm6ur6WX0CXf+4i4+E24c6KAdA8xlZFwPX8u1oDY8hrtbz
 arwDdBKdT+6Scd7PxPTPzrxSz/plj40wF6hCXeMqUer7ISEouM/BQNCkQcOW1u6H1JPv+SS4Z
 Ry69FxPybX1ML5fn8VwOGY5FXvDs9aj0jKF4zG7QaRtAzxED87AXl+8LKMWauudeMjaPYuFf3
 qeV/C0N1Jf+Ed5D6f3lM/DUv+86WMvCNCO+mJ+ZuU8C4bGFmi/SEUenIYjWrgv/FEnHDGdwjX
 BvJig73HaURVuDyO+l/LI+ibXpDJsV+pcNjqiy2ZspSJfo0InDGCbNhZCnWgdzuwtalCn4bp5
 3uRE4AkrrlLqx6pRuOBmEAKbim1DnOIDFjq0W+EXLwe8MGTguvGrci7zLuc5yc2uEzBOA1ocg
 5LoMwMSFs72b53e1TY1pf7AhpmbpH9SAV6VuApXfkjKdfwEpx9tn/Ed2g2u4+YTLeHz69B+fA
 j+0g61IvLEheuDP7WJVS2SxiEunii62O5C9pIaqLwZyYSntj/bQSbW4Aq/6vKVL9TZktj9E7e
 jyy5yvjnKb6HxpvEbDhbo5QsMUJoLqjLg/po0beCu9Di9dau/7tHSABLmOPheh6c3xUZS9y7F
 13KAV1QkR7okD5OvmpEfP4ws/TOIWzFqRxSYkbv9KvyZFXcf7/FBGmhr3vYfA4H7QgToSnJmj
 7bRM628pn4nk11s8pGxARjkmhWeHM6GS6X3MuD95M07GH+zMMzMepARgQmPBDDMeMMHatb5am
 QRIkMrKnP+GTM3J9AhyaH2hvqDPHfKOV/TflkaVJ6h96M6Ms9CTC8XDmr3dWNWpRHF4hA7avS
 WT2gI3QdflkF6cx5JIbmtkhDVaz3Lg5UyyVDKYwP+ZcfMxbuF9h0udYFhC4HVhPykoi7//t3v
 BKUoc7mvYm1Plaj//ih1JHFEliKOxVU/eES8H+/vKkSbEyTxusbBGYxOGnp6gWYJps47USrh6
 s3pVTNXFa7wHmWjpM8tf6eZns/hY5Rc486r+SP4e5dDyhPFtSQd5wT/qVoD4rwYqtwIv7wI+v
 sHpvyN/L1gRY0tpwKNDUst1JJRELkxzcr6thyCQWVm5avU31Fso8ytIfoSFuXzc/75hpSR1uw
 ydabGQPED+YkIzHkDiKIpgqMnl6YZvf5a9XXEqWpRlAhh3Y3NfdugLIp/X48=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In nl80211_get_ftm_responder_stats, a new skb is created via nlmsg_new
> named msg. If nl80211hdr_put() fails, then msg should be released. The
> return statement should be replace by goto to error handling code.

Please improve this change description (also by avoiding a typo).

Regards,
Markus

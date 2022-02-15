Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F794B67EE
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 10:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbiBOJml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 04:42:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiBOJmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 04:42:39 -0500
X-Greylist: delayed 68 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Feb 2022 01:42:27 PST
Received: from re-prd-fep-044.btinternet.com (mailomta25-re.btinternet.com [213.120.69.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F6D2C678;
        Tue, 15 Feb 2022 01:42:27 -0800 (PST)
Received: from re-prd-rgout-001.btmx-prd.synchronoss.net ([10.2.54.4])
          by re-prd-fep-047.btinternet.com with ESMTP
          id <20220215094117.GTWD23513.re-prd-fep-047.btinternet.com@re-prd-rgout-001.btmx-prd.synchronoss.net>;
          Tue, 15 Feb 2022 09:41:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=btinternet.com; s=btmx201904; t=1644918077; 
        bh=01Reov67Ak1ygfT60tyjXg/E5IFhGxMI7kxwA5g4ZyM=;
        h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:MIME-Version;
        b=onHcTnnrW4WCnKRqdkxuBRd07GbPtsX66B+GrLDMfQwWsohnkqMBz2DkaAIDBQzieWhz1toiEEuRGc7RmAHkp7Jd3TFlsSNPTS1dkdW91mvZ5+MsIgUzMElKeLyyQo1rgtB7eI/vvfQkQRjp9DEQHZNG2TfS2/y4NulukhnJHaT9FLZ+UOoT3WFuIsOTjX8Uf3OqpTEeuIW+EE4ZLYrRZ1eEC4Bb0W1nxIXVOAx7t80QUTfvvLkaLUC9HrRMVCOqldclPmbEccqvfHSCXSTRgbXOCyh3hlMZFbxjb99A6TpDGIQhX05CpdWTqBYa74nZ27GsKvaUoYybDewHHu6gjQ==
Authentication-Results: btinternet.com;
    auth=pass (LOGIN) smtp.auth=richard_c_haines@btinternet.com;
    bimi=skipped
X-SNCR-Rigid: 613A8CC314A977E6
X-Originating-IP: [81.154.227.201]
X-OWM-Source-IP: 81.154.227.201 (GB)
X-OWM-Env-Sender: richard_c_haines@btinternet.com
X-VadeSecure-score: verdict=clean score=0/300, class=clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedvvddrjeeggddtiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemuceutffkvffkuffjvffgnffgvefqofdpqfgfvfenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkffuhffvffgjfhgtfggggfesthekredttderjeenucfhrhhomheptfhitghhrghrugcujfgrihhnvghsuceorhhitghhrghruggptggphhgrihhnvghssegsthhinhhtvghrnhgvthdrtghomheqnecuggftrfgrthhtvghrnhepueeitdegtdegvdffjeetfeeffedvgedvteetffeuueekueejkeevkefgfefffedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpghhithhhuhgsrdgtohhmnecukfhppeekuddrudehgedrvddvjedrvddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopegludelvddrudeikedruddrudelkegnpdhinhgvthepkedurdduheegrddvvdejrddvtddupdhmrghilhhfrhhomheprhhitghhrghruggptggphhgrihhnvghssegsthhinhhtvghrnhgvthdrtghomhdpnhgspghrtghpthhtohepudefpdhrtghpthhtohepuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopehkuhgsrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqshgt
        thhpsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqshgvtghurhhithihqdhmohguuhhlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehluhgtihgvnhdrgihinhesghhmrghilhdrtghomhdprhgtphhtthhopehmrghrtggvlhhordhlvghithhnvghrsehgmhgrihhlrdgtohhmpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepnhhhohhrmhgrnhesthhugigurhhivhgvrhdrtghomhdprhgtphhtthhopehomhhoshhnrggtvgesrhgvughhrghtrdgtohhmpdhrtghpthhtohepphgruhhlsehprghulhdqmhhoohhrvgdrtghomhdprhgtphhtthhopehsvghlihhnuhigsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhihrghsvghvihgthhesghhmrghilhdrtghomh
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-SNCR-hdrdom: btinternet.com
Received: from [192.168.1.198] (81.154.227.201) by re-prd-rgout-001.btmx-prd.synchronoss.net (5.8.716.04) (authenticated as richard_c_haines@btinternet.com)
        id 613A8CC314A977E6; Tue, 15 Feb 2022 09:41:17 +0000
Message-ID: <cddf0d41fdc23b594780012df367ad8bdd9dc135.camel@btinternet.com>
Subject: Re: [PATCH net v3 0/2] security: fixups for the security hooks in
 sctp
From:   Richard Haines <richard_c_haines@btinternet.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, selinux@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 15 Feb 2022 09:41:17 +0000
In-Reply-To: <20220212175922.665442-1-omosnace@redhat.com>
References: <20220212175922.665442-1-omosnace@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-02-12 at 18:59 +0100, Ondrej Mosnacek wrote:
> This is a third round of patches to fix the SCTP-SELinux interaction
> w.r.t. client-side peeloff. The patches are a modified version of Xin
> Long's patches posted previously, of which only a part was merged
> (the
> rest was merged for a while, but was later reverted):
> https://lore.kernel.org/selinux/cover.1635854268.git.lucien.xin@gmail.com/T/
> 
> In gist, these patches replace the call to
> security_inet_conn_established() in SCTP with a new hook
> security_sctp_assoc_established() and implement the new hook in
> SELinux
> so that the client-side association labels are set correctly (which
> matters in case the association eventually gets peeled off into a
> separate socket).
> 
> Note that other LSMs than SELinux don't implement the SCTP hooks nor
> inet_conn_established, so they shouldn't be affected by any of these
> changes.
> 
> These patches were tested by selinux-testsuite [1] with an additional
> patch [2] and by lksctp-tools func_tests [3].
> 
> Changes since v2:
> - patches 1 and 2 dropped as they are already in mainline (not
> reverted)
> - in patch 3, the return value of security_sctp_assoc_established()
> is
>   changed to int, the call is moved earlier in the function, and if
> the
>   hook returns an error value, the packet will now be discarded,
>   aborting the association
> - patch 4 has been changed a lot - please see the patch description
> for
>   details on how the hook is now implemented and why
> 
> [1] https://github.com/SELinuxProject/selinux-testsuite/
> [2]
> https://patchwork.kernel.org/project/selinux/patch/20211021144543.740762-1-omosnace@redhat.com/
> [3] https://github.com/sctp/lksctp-tools/tree/master/src/func_tests
> 
> Ondrej Mosnacek (2):
>   security: add sctp_assoc_established hook
>   security: implement sctp_assoc_established hook in selinux
> 
>  Documentation/security/SCTP.rst | 22 ++++----
>  include/linux/lsm_hook_defs.h   |  2 +
>  include/linux/lsm_hooks.h       |  5 ++
>  include/linux/security.h        |  8 +++
>  net/sctp/sm_statefuns.c         |  8 +--
>  security/security.c             |  7 +++
>  security/selinux/hooks.c        | 90 ++++++++++++++++++++++++-------
> --
>  7 files changed, 103 insertions(+), 39 deletions(-)
> 

Built this patchset on kernel 5.17-rc4 with no problems.
Tested using [PATCH testsuite v3] tests/sctp: add client peeloff tests

Tested-by: Richard Haines <richard_c_haines@btinternet.com>



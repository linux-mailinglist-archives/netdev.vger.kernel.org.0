Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6BC642376
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiLEHNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiLEHNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:13:43 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BD8DF00;
        Sun,  4 Dec 2022 23:13:41 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 40ED9C009; Mon,  5 Dec 2022 08:13:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1670224429; bh=2/E7M28jlzB+tOHKj9EI5rF1sUTSmV05NM5sZZy2Ges=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B0zWuxAWobbgFEMxbhwX4lp5iaDuYpVNfYEbFdypNE9BAEAUfyDNFOZ9FJxGQIdsa
         b8O8XLAwsW93DcGQ3Q4PU3/Lta6koQ9lky6cmm3lfMhbiiA46TsCstjXBH999VsiNu
         +g+UGbZ/ZI0sN+KWbwUv/pRW69a6gCgVxnjLgvbFBVlTAWRndzp8T/zJdsaVi0zHgy
         w5r04KLoMbSVP7SFddKajyEj99IP8NkLmjCPuzsE1nZVZ5mvPDyRV144nm9oICY2Cy
         1whWO7gJ3/KnNTjVIH5LIa0I6FJlll7IosmDfBEZKVNGoLLzb0Wyt/2gFNpM4NB9uD
         TY9Y5Y2mDRT+g==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 60CC5C009;
        Mon,  5 Dec 2022 08:13:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1670224428; bh=2/E7M28jlzB+tOHKj9EI5rF1sUTSmV05NM5sZZy2Ges=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KxQeiB3TMfEP8TdHuiQ+mAFsfqmEjCtnUMdRLDavqny0AJ9quC85bvFEBSntRx1EW
         kjheht3Ihlt2CF/xQPWMOwq5Hp75OT1K383041mHB0mzWog1mpMI4WaQBmkJkYT7Ut
         qc0RVIfxvC04axDWpXmw086FQ2t/l35XCHSiqlIzYMqDz+K9YUpMXV5nxgGYli3Hrw
         Kgq6sdVe8hA1CS/X51+825I4x+cBiWzHHw2YUdFUClSMpRA3HGpm2UG+i+a0wx3vZb
         xKkm9DY1ftW3CzJ8CI0eeoJ+3T+iZoug4LvDwB+Nn8oZ4GFo/0dv5qbuFR9SS2ESgJ
         QV9Y9Zr30M2zg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id d99753f1;
        Mon, 5 Dec 2022 07:13:32 +0000 (UTC)
Date:   Mon, 5 Dec 2022 16:13:17 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Marco Elver <elver@google.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        rcu <rcu@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kunit-dev@googlegroups.com, lkft-triage@lists.linaro.org,
        kasan-dev <kasan-dev@googlegroups.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: arm64: allmodconfig: BUG: KCSAN: data-race in p9_client_cb /
 p9_client_rpc
Message-ID: <Y42aDQ0ZOUt4dvYc@codewreck.org>
References: <CA+G9fYsK5WUxs6p9NaE4e3p7ew_+s0SdW0+FnBgiLWdYYOvoMg@mail.gmail.com>
 <CANpmjNOQxZ--jXZdqN3tjKE=sd4X6mV4K-PyY40CMZuoB5vQTg@mail.gmail.com>
 <CA+G9fYs55N3J8TRA557faxvAZSnCTUqnUx+p1GOiCiG+NVfqnw@mail.gmail.com>
 <Y4e3WC4UYtszfFBe@codewreck.org>
 <CA+G9fYuJZ1C3802+uLvqJYMjGged36wyW+G1HZJLzrtmbi1bJA@mail.gmail.com>
 <Y4ttC/qESg7Np9mR@codewreck.org>
 <CANpmjNNcY0LQYDuMS2pG2R3EJ+ed1t7BeWbLK2MNxnzPcD=wZw@mail.gmail.com>
 <Y4vW4CncDucES8m+@codewreck.org>
 <CANpmjNPXhEB6GeMT70UT1e-8zTHf3gY21E3wx-27VjChQ0x2gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANpmjNPXhEB6GeMT70UT1e-8zTHf3gY21E3wx-27VjChQ0x2gA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marco Elver wrote on Mon, Dec 05, 2022 at 08:00:00AM +0100:
> > Should I just update the wrapped condition, as below?
> >
> > -       err = wait_event_killable(req->wq, req->status >= REQ_STATUS_RCVD);
> > +       err = wait_event_killable(req->wq,
> > +                                 READ_ONCE(req->status) >= REQ_STATUS_RCVD);
> 
> Yes, this looks good!
> 
> > The writes all are straightforward, there's all the error paths to
> > convert to WRITE_ONCE too but that's not difficult (leaving only the
> > init without such a marker); I'll send a patch when you've confirmed the
> > read looks good.
> > (the other reads are a bit less obvious as some are protected by a lock
> > in trans_fd, which should cover all cases of possible concurrent updates
> > there as far as I can see, but this mixed model is definitely hard to
> > reason with... Well, that's how it was written and I won't ever have time
> > to rewrite any of this. Enough ranting.)
> 
> If the lock-protected accesses indeed are non-racy, they should be
> left unmarked. If some assumption here turns out to be wrong, KCSAN
> would (hopefully) tell us one way or another.

Great, that makes sense.

I've left the commit at home, will submit it tonight -- you and Naresh
will be in Cc from suggested/reported-by tags.

-- 
Dominique

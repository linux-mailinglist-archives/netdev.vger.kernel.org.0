Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAE76D5383
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjDCVce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbjDCVcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:32:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB33173F;
        Mon,  3 Apr 2023 14:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30CD561C55;
        Mon,  3 Apr 2023 21:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB051C433EF;
        Mon,  3 Apr 2023 21:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680557551;
        bh=/U885SDhNjytagNMIR/JlAaotK6K5qta/BrLuv4adJ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GDKqaKal65yQRgU4zSAT/ynOdxRO0pRJs63EA2mUkmq2Pb6+Ks0JS6gs3736nCsWI
         S8rMSNuErU0DBBWnpaOXoJHApDLirhAZ+Kw2MZ+FakIei4VaNTtPsRnDefK2msNG0p
         N+LsiqEchPYXc/ULK2TmDMX7+5XWJZ8ZUO/nYqFFjA2o5gs4tMF0mmMvbCg3hTztKi
         K9k78PN6GKJvBoTBRLcyWnuaIeTm4tqfxW1PkYGrrVoKj1BRWPV9HH8kHNoE9+SfL5
         j510OT2esNWbeK+uH0sK+hvNpeukm2Uvikda33JQ8zszIWYxPoXyycaSHWvuFh4yMN
         0Q71I+lpBsz4g==
Date:   Mon, 3 Apr 2023 14:32:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/9] Add tc-mqprio and tc-taprio support for
 preemptible traffic classes
Message-ID: <20230403143229.415ede88@kernel.org>
In-Reply-To: <20230403110458.3l6dh3yc5mtwkdad@skbuf>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
        <20230403110458.3l6dh3yc5mtwkdad@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 14:04:58 +0300 Vladimir Oltean wrote:
> On another note, this patch set just got superseded in patchwork:
> https://patchwork.kernel.org/project/netdevbpf/cover/20230403103440.2895683-1-vladimir.oltean@nxp.com/
> after I submitted an iproute2 patch set with the same name:
> https://patchwork.kernel.org/project/netdevbpf/cover/20230403105245.2902376-1-vladimir.oltean@nxp.com/
> 
> I think there's a namespacing problem in patchwork's series detection
> algorithm ("net-next" is not "iproute2-next", and so, it is valid to
> have both in flight) but I don't know where to look to fix that.
> Jakub, could you perhaps help, please?

I revived the series. I'm a bit weary about asking Konstantin to make
the pw-bot compare tree tags because people change trees all the time
(especially no tree -> net-next / net) and he would have to filter out
the version.. It's gonna get wobbly. Let's see if the problem gets more
common.

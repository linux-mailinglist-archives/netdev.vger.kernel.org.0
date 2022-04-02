Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA8D4F03D4
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 16:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346612AbiDBOQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 10:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238179AbiDBOQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 10:16:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D973D1C4;
        Sat,  2 Apr 2022 07:14:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1naeW2-0005EG-Ka; Sat, 02 Apr 2022 16:14:10 +0200
Date:   Sat, 2 Apr 2022 16:14:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jaco Kroon <jaco@uls.co.za>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>, Wei Wang <weiwan@google.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
Message-ID: <20220402141410.GE28321@breakpoint.cc>
References: <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za>
 <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za>
 <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
 <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
 <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
 <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jaco Kroon <jaco@uls.co.za> wrote:
> Including sysctl net.netfilter.nf_conntrack_log_invalid=6- which
> generates lots of logs, something specific I should be looking for?  I
> suspect these relate:
> 
> [Sat Apr  2 10:31:53 2022] nf_ct_proto_6: SEQ is over the upper bound
> (over the window of the receiver) IN= OUT=bond0
> SRC=2c0f:f720:0000:0003:d6ae:52ff:feb8:f27b
> DST=2a00:1450:400c:0c08:0000:0000:0000:001a LEN=2928 TC=0 HOPLIMIT=64
> FLOWLBL=867133 PROTO=TCP SPT=48920 DPT=25 SEQ=2689938314 ACK=4200412020
> WINDOW=447 RES=0x00 ACK PSH URGP=0 OPT (0101080A2F36C1C120EDFB91) UID=8
> GID=12

I thought this had "liberal mode" enabled for tcp conntrack?
The above implies its off.

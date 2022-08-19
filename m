Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC6E59A60E
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 21:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350316AbiHSTQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 15:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349775AbiHSTQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 15:16:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26FD10EEEC;
        Fri, 19 Aug 2022 12:16:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09A2B614C0;
        Fri, 19 Aug 2022 19:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AE3C433D6;
        Fri, 19 Aug 2022 19:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660936566;
        bh=usNel/o4HQgfRZ6RhtItYeTZNwWKzy6VV0zbTa43eQY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DpmFVl9O6LSxApOmC1TMXMhJQzZWgSLbuSA7mY8ioo+Es810UZJ6NrSVJirwpxSW/
         +kzh8XC9cIanr3b/REIFYbbMh0ZbA92QQmON6VEdKxZ5ChYK/s+vMmaDwmhkqw2IBf
         ZgMJLaAaHbZCC3oLEf3fLDAV/oS8PlyHPPWkw6r7hzEK18ys/vmuNVsFKkPDwVtzW9
         fuZ3b8OLrSyuDwsfVlg2Qsw2JlwSEcTfD20B9AT8K9tViBVk0M6BiU+Q199tHBpvgK
         CqUswyLKya9pASo+Wp/4BKnrv+S1093cJ9FwDBLRN5I3ZPB+dhwyXGTVoPv508AAqv
         QiKUeELEZGRvg==
Date:   Fri, 19 Aug 2022 12:16:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, corbet@lwn.net,
        stephen@networkplumber.org, sdf@google.com, ecree.xilinx@gmail.com,
        benjamin.poirier@gmail.com, idosch@idosch.org,
        f.fainelli@gmail.com, jiri@resnulli.us, dsahern@kernel.org,
        fw@strlen.de, linux-doc@vger.kernel.org, jhs@mojatatu.com,
        tgraf@suug.ch, jacob.e.keller@intel.com, svinota.saveliev@gmail.com
Subject: Re: [PATCH net-next 2/2] docs: netlink: basic introduction to
 Netlink
Message-ID: <20220819121604.04d365c3@kernel.org>
In-Reply-To: <fa41284993d7e1c629b829ec40fdbbd4d68cbed7.camel@sipsolutions.net>
References: <20220818023504.105565-1-kuba@kernel.org>
        <20220818023504.105565-2-kuba@kernel.org>
        <6350516756628945f9cc1ee0248e92473521ed0b.camel@sipsolutions.net>
        <20220819092029.10316adb@kernel.org>
        <959012cfd753586b81ff60b37301247849eb274c.camel@sipsolutions.net>
        <20220819105451.1de66044@kernel.org>
        <fa41284993d7e1c629b829ec40fdbbd4d68cbed7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 21:07:36 +0200 Johannes Berg wrote:
> > The notification contains the same information as the response to the
> > ``CTRL_CMD_GETFAMILY`` request. It is most common for "new object"
> > notifications to contain the same exact data as the respective ``GET``.  
> 
> I might say we should remove that second sentence - this is one of those
> murky cases where it's actually sometimes not _possible_ to do due to
> message size limitations etc.
> 
> That said, it's still common, so maybe that's OK, "common" doesn't mean
> "always" and some notifications might obviously differ even if it's
> common.

I'll rephrase, I'll just say that in this case it's the same message.

> > The socket will now receive notifications. It is recommended to use
> > a separate sockets for receiving notifications and sending requests
> > to the kernel. The asynchronous nature of notifications means that
> > they may get mixed in with the responses making the parsing much
> > harder.  
> 
> Not sure I'd say "parsing" here, maybe "message handling"? I mean, it's
> not really about parsing the messages, more about the potentially
> interleaved sequence of handling them. But maybe I'm splitting hairs :)

Yup, that's better. Let me revisit this paragraph, it doesn't read too
smoothly :S

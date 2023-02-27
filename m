Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6F16A4543
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 15:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjB0Oym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 09:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjB0Oyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 09:54:41 -0500
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 27 Feb 2023 06:54:35 PST
Received: from titan.fastwww.net (titan10.fastwww.net [198.27.78.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53279EF1
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 06:54:35 -0800 (PST)
Comment: DomainKeys? See http://domainkeys.sourceforge.net/
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=lockie.ca;
  b=DM+MDZEQP97HEI7KV2s2RjfFxRwuEZfVy9w88pfDgGlE1WM21bm80e3+ejrG+nwUakStyzACTVaZRlHh4TfaSuBNAQ9k9zmf3gMZ1NelS3YgFsBrST+6j4Gq86LykjkJSFbQFXbmew7pggNvfy3k/R3Qw7Cx1OYYgIoYwYI6x26lx6Bv29gq/OyybzR3/+V04LBnEmQptROmZeQ/ZO0MSmrUwpQ8fsIsiF9trQpitftBVsd733vtHfF/JBXY12lY88ajs+9bN6mKUJdpWP4rdcOGAyHrv3G6Z2VUSnTK4o2KsSOPn0Ran2YyvTh0aFv48QDWM8BRMvMk3Sa0ncgyEA==;
  h=Received:Received:Received:Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Correlation-ID;
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=lockie.ca; h=date:from:to
        :cc:message-id:in-reply-to:references:subject:mime-version
        :content-type:content-transfer-encoding; s=default; bh=DH1k7jB0W
        DnqE7KpUduC5ZHagjc=; b=PDpLJKDe9pO5JFkAtV2WwwVQuPEq7MTBFoGIsVR6P
        R2ijiIk0nXbC1brkPtZKOXBk2nSQaA3xy4jP0rZdcF3GA+YQKVqv52LBB27r8ner
        RX9DHrij4DvCIaAOegl6vwmKHmdsZtv/NTXqqTdEU5aZc/ZgtkPZbu+rCL8H4dOi
        b9yOxkjt/Fu1XVp6HwvdohhC3gJXOp6f2iKOKVSbdg4vD9eZXEy7Hgizq9JpyIUl
        tjL9m05Nlw3CWFoi3xPuzJ8jHy1z8con+uqglxWrq333JUs0q/lEaYBv52lehA9s
        qT9z5RlhkaFX+kSKos5a7OBep2OOIpeer782NQibrxz+w==
Received: (qmail 1835 invoked by uid 108); 27 Feb 2023 14:47:54 +0000
Received: from unknown (HELO titan.fastwww.net) (127.0.0.1)
  by titan.fastwww.net with SMTP; 27 Feb 2023 14:47:54 +0000
Received: from dummy.faircode.eu ([98.124.13.21])
        by titan.fastwww.net with ESMTPSA
        id OfNgO5nC/GMmBwAApSktOw
        (envelope-from <bjlockie@lockie.ca>); Mon, 27 Feb 2023 14:47:53 +0000
Date:   Mon, 27 Feb 2023 09:47:51 -0500 (EST)
From:   James <bjlockie@lockie.ca>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <2df898bc-18a3-4e6d-856f-ce303cb38889@lockie.ca>
In-Reply-To: <939a51b6-25f7-2cb1-d86e-0bcead931876@molgen.mpg.de>
References: <939a51b6-25f7-2cb1-d86e-0bcead931876@molgen.mpg.de>
Subject: Re: What to do about warnings: `WRT: Overriding region id X`
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <2df898bc-18a3-4e6d-856f-ce303cb38889@lockie.ca>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Feb. 27, 2023 09:34:36 Paul Menzel <pmenzel@molgen.mpg.de>:

> What can a user do about these warnings?

Don't look at them? :-)

Are there any parameters for the module?
modinfo iwlwifi

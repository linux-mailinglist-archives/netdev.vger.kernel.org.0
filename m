Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35B364CD7C
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 16:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238887AbiLNP41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 10:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238214AbiLNPz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 10:55:59 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D169D22B31;
        Wed, 14 Dec 2022 07:53:56 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 0B6F432002D8;
        Wed, 14 Dec 2022 10:53:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 14 Dec 2022 10:53:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1671033233; x=1671119633; bh=CyIY8Drrva
        YiKFF2vUOVJLvYII5yfxQR4YH6JCbvsJ4=; b=MvRAhVA2FjrgQ/rTVnDffGST7n
        e9sN0liY4NK15kqxO/PNN4vq+yXdmZp3YrWGguGUQODuuXOM6peOVClo6tQwfuZs
        Y6kEVVnFGzI/S9kiXWha9z+PCFVKU2hJE4iwVhHdcrxxJ1LBWX9Sg5NwV9MczOZp
        eEokm0vWdYTFP8+Zv1NUIyRJ0PJ8Z5esi0vT9SMiZyt+62HmCzYTqTgpU/K/HZi2
        mzp7hl3rNnQsr4x3vYRKStVGRpBNu7zAaQ5AM+k5LMLF+uwJ6Y9oSc1tJRlHkQb9
        A5wMCcpdxJyTecLFUL6Y5SG4B64Vl8E/IYuEyXTHUVCmBdxMAEKkGjlSm4qg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1671033233; x=1671119633; bh=CyIY8DrrvaYiKFF2vUOVJLvYII5y
        fxQR4YH6JCbvsJ4=; b=KtQJIImGbePM5JQOFehBhSMglottTdzLrTixlGhk2oht
        biCrtesqLjjpYVRUm/sT2u5wcbhQy4Yy79/gtADsiUi0JbY6zUJzLUip1K3UH/1Z
        jtncNLTdSjbKApBsr9txlYjuwh/Ht2iCaEifKj9yX2QWWVTDxMK9AnmTGYlbKczW
        6JA1Cm9j+rjJHT8uJEfhKgB8k3CDc2XrGZWhY2eYoX6wY4zAePxRpqdEWUnbIkM+
        iwiyW45qrdnmuBO+lm4VvfnHBlFRFyOh9y+coTYOtbhJDeo94NXXLQkvcbDHnzgg
        oTslTdE8D+Bd7bGgva2jzz6/KY6M2TIiZ6zkRZj/6g==
X-ME-Sender: <xms:kfGZY_8LTIE8_bkXs3JTJ3CwBOyRdqOhRo9cy4Ly1wdObLjoMl5CCw>
    <xme:kfGZY7tRMtl_uw_q4dEgucVMAuvfceHPqyk-mHBQVTAq9eO-1_--swZj26lk8YXNU
    p6qA9c1N_yqJQ>
X-ME-Received: <xmr:kfGZY9Amnyl2gGbI0N6e0YpuhCPNfjgLpkV4zGTAifo52anXavzl7yZJJxsZkCAei0uONGU8_KsWmsjLBQEO8yUJUh9Cgas8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeefgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kfGZY7fSRSKir-cCW7XbfI5LOyRgKhEcCwK3UytS9kOKh5C_LlD7-A>
    <xmx:kfGZY0PmAoJXzokl9tlHC_IO7aE1pyLzAzP3bUEluWyjE_k4V7TPhA>
    <xmx:kfGZY9nYxtaFrqDRY8J8vl79eStAjk61bBBB9kv-K3FTQXtyPa8_Yg>
    <xmx:kfGZYxrdgRyrT7E_wf86Fs5MVjxAUqS3u0rX0PLHOeyQ8dL28c2v6A>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Dec 2022 10:53:52 -0500 (EST)
Date:   Wed, 14 Dec 2022 16:53:50 +0100
From:   Greg KH <greg@kroah.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     stable <stable@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: Request for "net: bpf: Allow TC programs to call
 BPF_FUNC_skb_change_head" in 5.4
Message-ID: <Y5nxjuRGdUDmEStG@kroah.com>
References: <b5353d33-728e-db34-e65b-d94cddaf8547@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5353d33-728e-db34-e65b-d94cddaf8547@6wind.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 11:57:32AM +0100, Nicolas Dichtel wrote:
> Hi,
> 
> I would like to request for cherry-picking commit 6f3f65d80dac (linux v5.8) in
> the linux-5.4.y branch.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6f3f65d80dac
> 
> This commit is trivial, the potential regressions are low. The cherry-pick is
> straightforward.
> The kernel 5.4 is used by a lot of vendors, having this patch will help
> supporting standard ebpf programs.

Now queued up, thanks.

greg k-h

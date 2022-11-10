Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F2C624E9A
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 00:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiKJXzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 18:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiKJXzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 18:55:24 -0500
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A5611A24;
        Thu, 10 Nov 2022 15:55:23 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 8BAA82B067E9;
        Thu, 10 Nov 2022 18:55:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 10 Nov 2022 18:55:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1668124518; x=1668128118; bh=GlHnesMTaT
        HPOW5v2dVqh6mrEs/2tfUVgZLuAhyUON4=; b=VJJa9HXQQdrqzha7u9staRnQGV
        L+KlkG4DXHBuBtF6BHtkyXXrSs0paGWAht51JwICosxk/jwIjD7fH3D22RHwZ2eP
        VgHR+hBabIBaNCZLgyT8Zh+gvXXixIAoVEJ/vcgHPO1ou8V1Fu9nJmIsAHkPwQJV
        /3bA4frZ+GMTsNHz4HYX0cPprAAF1K6KNQrnu3gqWPJjiLTusBjWL5O/28J3pH4U
        StSVwzZ28oSVt7TvaynqiqhclDg04JWPUU1tnxAJKbU/TMeTVi8QrJdu8j8tcaWC
        NoXlYe2P1EkEy8TPvyf/y3NEMXIYtYiO1aNVZpQiwoXrQOXY7Y/MN8KYcOaQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668124518; x=1668128118; bh=GlHnesMTaTHPOW5v2dVqh6mrEs/2
        tfUVgZLuAhyUON4=; b=UELb4RTqh5k7s5Y9IgTet29BBr/ATHTvmiAW7l97JDbZ
        JpXPNqFCqRmjPTltxyqaEHszByDOOEfCCXs24oySmmd5JDqScFWOB6bSi8AhlRyD
        nlnQ494bXcQB25zDg66FceQ0bOGL8TGc8O/05HNUp4MWKBOjO/jUIoWdyDl5yPGf
        xiKYYhBwRXwPqyUXvFNP/vshKFr5djdvdbFF0wSSxDQf/B+ePyYIo2k7bqGofLB8
        UiqWCqT097pxopgAX0XVxgNNKaxRGvqK3yajZUqMc3xnZE6DDHvyFlZRp9cQ8Wt4
        1LH9bECa8a+31yZwCzu6Rsp9+6Pnb21+cw1oziAwNg==
X-ME-Sender: <xms:ZY9tY-9K9LSCkFObbXSc3o6qeXxKFjAcqo291uWuzFLePGxTkU68hg>
    <xme:ZY9tY-u9oCVGrLw0XRGZG6G54hC3jQgS3IbTe19_d7RBmYcgZGKp260yCnqS_Px7G
    7FyXU_bt_Ac4F1HuKo>
X-ME-Received: <xmr:ZY9tY0BXFkbcdXkb34e7hNS-54K5xjLcoFSeit1BHPmCdAgNw3A4zlQj3MKlrnLnXIiuosTjyckTmnCIX0kzAwshYR-JIOMIdMORlm4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfeehgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfhgfhffvvefuffgjkfggtgesthdtre
    dttdertdenucfhrhhomhepufhtvghfrghnucftohgvshgthhcuoehshhhrseguvghvkhgv
    rhhnvghlrdhioheqnecuggftrfgrthhtvghrnhepveelgffghfehudeitdehjeevhedthf
    etvdfhledutedvgeeikeeggefgudeguedtnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepshhhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:ZY9tY2cSyh1-WpCkBVb3qyALlnnL_rOUO4nT88ca-94RKjxtHH_UoA>
    <xmx:ZY9tYzMkysBUKkJo1fkaiydQ6xMhEq98X6u_NAbHhzc2IQaZkYnqnQ>
    <xmx:ZY9tYwnYgcy-8gM0fV2ATzrT4zIo3IDvHIxbYpkfyehxybNruv3Ckg>
    <xmx:ZY9tY4oiLX8H-W8O06IAVN-GoD0DBvJOQIF8G5WfpUWUOw0ire4hsl_m5ss>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Nov 2022 18:55:16 -0500 (EST)
References: <20221107175240.2725952-1-shr@devkernel.io>
 <20221107175240.2725952-2-shr@devkernel.io>
 <20221108165659.59d6f6b1@kernel.org>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kernel-team@fb.com, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] io_uring: add napi busy polling support
Date:   Thu, 10 Nov 2022 15:36:34 -0800
In-reply-to: <20221108165659.59d6f6b1@kernel.org>
Message-ID: <qvqweduae55u.fsf@dev0134.prn3.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Mon,  7 Nov 2022 09:52:39 -0800 Stefan Roesch wrote:
>> This adds the napi busy polling support in io_uring.c. It adds a new
>> napi_list to the io_ring_ctx structure. This list contains the list of
>> napi_id's that are currently enabled for busy polling. The list is
>> synchronized by the new napi_lock spin lock. The current default napi
>> busy polling time is stored in napi_busy_poll_to. If napi busy polling
>> is not enabled, the value is 0.
>>
>> The busy poll timeout is also stored as part of the io_wait_queue. This
>> is necessary as for sq polling the poll interval needs to be adjusted
>> and the napi callback allows only to pass in one value.
>>
>> Testing has shown that the round-trip times are reduced to 38us from
>> 55us by enabling napi busy polling with a busy poll timeout of 100us.
>
> What's the test, exactly? What's the network latency? Did you busy poll
> on both ends?
>

The test programs are part of the liburing patches. They consist of a
client and server program. The client sends a request, which has a timestamp
in its payload and the server replies with the same payload. The client
calculates the roundtrip time and stores it to calcualte the results.

The client is running on host1 and the server is running on host 2. The
measured times below are roundtrip times. These are average times over
10 runs each.

If no napi busy polling wait is used                 : 55us
If napi with client busy polling is used             : 44us
If napi busy polling is used on the client and server: 38us

If you think the numbers are not that useful, I can remove them from the
commit message.

> I reckon we should either find a real application or not include any
> numbers. Most of the quoted win likely comes from skipping IRQ
> coalescing. Which can just be set lowered if latency of 30usec is
> a win in itself..
>
> Would it be possible to try to integrate this with Jonathan's WIP
> zero-copy work? I presume he has explicit NAPI/queue <> io_uring
> instance mapping which is exactly the kind of use case we should
> make a first-class citizen here.
>

I'll have a look at Jonathan's patches.

>> +	spin_lock(&ctx->napi_lock);
>> +	list_for_each_entry(ne, &ctx->napi_list, list) {
>> +		if (ne->napi_id == napi_id) {
>> +			ne->timeout = jiffies + NAPI_TIMEOUT;
>
> What's the NAPI_TIMEOUT thing? I don't see it mentioned in
> the commit msg.
>

To make sure that the napi id's are cleaned up, they have a timeout. The
function io_napi_check_entry_timeout checks if the timeout expired. This
has been added to make sure the list does not grow without bound.

>> +	list_for_each_entry_safe(ne, n, napi_list, list) {
>> +		napi_busy_loop(ne->napi_id, NULL, NULL, true, BUSY_POLL_BUDGET);
>
> You can't opt the user into prefer busy poll without the user asking
> for it. Default to false and add an explicit knob like patch 2.
>

The above code is from the function io_napi_blocking_busy_loop().
However this function is only called when a busy poll timeout has been
configured.

#ifdef CONFIG_NET_RX_BUSY_POLL
         if (iowq.busy_poll_to)
                 io_napi_blocking_busy_loop(&local_napi_list, &iowq);

However we don't have that check for sqpoll, so we should add a check
for the napi busy poll timeout in __io_sq_thread.

Do we really need a knob to store if napi busy polling is enabled or is
sufficent to store a napi busy poll timeout value?

>>  		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
>>  	}
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	else if (!list_empty(&local_napi_list)) {
>> +		iowq.busy_poll_to = READ_ONCE(ctx->napi_busy_poll_to);
>> +	}
>> +#endif
>
> You don't have to break the normal bracket placement for an ifdef:
>
> 	if (something) {
> 		boring_code();
>
> #ifdef CONFIG_WANT_CHEESE
> 	} else if (is_gouda) {
> 		/* mmm */
> 		nom_nom();
> #endif
> 	}

I'll fix the above with the next version of the patch.
'

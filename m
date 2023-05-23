Return-Path: <netdev+bounces-4626-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 046C270D9AF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C586D1C20CF5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F145E1E533;
	Tue, 23 May 2023 09:58:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E421E1E516
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:58:03 +0000 (UTC)
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F9894
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:58:01 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.west.internal (Postfix) with ESMTP id 8CD1F3200921;
	Tue, 23 May 2023 05:57:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 23 May 2023 05:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1684835877; x=1684922277; bh=Oo
	TsBzUD2xCCsXs4s1laa9Pfy6QKSY1VLVq985oYaI0=; b=wCq9LBasuqwgE5YiRx
	xlpJkyq6/GQpoTnhUYFpGYmLspG5Y2vKtiqrIi4+iza/Etfo1hokvjuRlAcnvvl+
	+11e6p+SrTVOcnSEcP5cgRVrXG7ffLSY4w5NyFTVTobZX0ONgMONMH1awIf0a/84
	dOJjh0gMFNt8CQXb1tGKEtnWj+a+qOuoPOVRhGJZ8BoXeHN0lFlfoBzZOHiUqyQA
	aBwVfwzzhxzT+eUogvSnTIswr+3y24loa7JoLtWjmptq0sCrnz94XEP0bRHiwfyT
	UwASn30e6Bl1C3VvmKDBXUmJ28R5L5nirbncv2nQBWRO4eQ/VKqSdUql/q7erX7v
	THyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684835877; x=1684922277; bh=OoTsBzUD2xCCs
	Xs4s1laa9Pfy6QKSY1VLVq985oYaI0=; b=jrvPuf9R+iF/5kTf3LD8utHCwxotz
	5+ZeuhHWOfPpX4Ax/EW9nZh9CzPX+sun+GPWv0CBFar6ldgi9WtNib3X25VBmQBc
	pxiPwp7tfQ5YDpFWZp4cvM7jrf0jjw8F0KmjosMxRd654GQcczdAqzSy9c0hZ1tz
	HMsyG+R1E4+5fkohoEY4UY2tUO7Z6qGosIadH64N2yw1pMBVAsXb0NZWe5YXM5ZS
	aQqHngdk4SodDUO3vO+xC6IyHGPHbjpofF9rg5Dwa+dZBLcroIwy0SUdngkiqbft
	dVCfz8dn7CVIFBw/NPVe2ex8QzGQjvgq9csrwyUtc1z65qFCr+SbmQawg==
X-ME-Sender: <xms:JI5sZC7SjoEhcUyXPl5pReOsSB5whCFEoOhOR8tAP98MIsabSwANAQ>
    <xme:JI5sZL7tAmlMDfHzyv3K0Us1z-Qs0hjRAbn3rG2Knb2zggEG0MDKCCcmfhZiOfvgd
    SNsKjuXEtyd5lc12gs>
X-ME-Received: <xmr:JI5sZBdGYD6s4xSyogF1aIqO45ZHI2j4Rr7OmmXD2Zyj8KQSJEB7STwSKImtrPjR8s3mMZ0RElw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeejfedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdljedmnecujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttder
    tdenucfhrhhomhepgghlrgguihhmihhrucfpihhkihhshhhkihhnuceovhhlrgguihhmih
    hrsehnihhkihhshhhkihhnrdhpfieqnecuggftrfgrthhtvghrnhepiefgvdegieeiledu
    heeuueeujeeiieehgeduvefhgfeggeduvdevudeuheeufeegnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepvhhlrgguihhmihhrsehnihhkihhs
    hhhkihhnrdhpfi
X-ME-Proxy: <xmx:JI5sZPLtDeJtTlQyrCbRwn1IHhQMy41Jo7IWKMa7QlTv1U9sewD5Pg>
    <xmx:JI5sZGKAETeFp-LhezW4OC8lxaxjjagBuViH3exDiSava35x0q87FQ>
    <xmx:JI5sZAxSCgMMCtBpthxGwT5ZO6aW7M7Vza85YuYbOAo2Zn5v-AC2Xw>
    <xmx:JY5sZIhVha4XmBzAzBcvySbQ0b_iTj6nufj8c0DwI13OPRgQOFVy0A>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 May 2023 05:57:52 -0400 (EDT)
References: <20230521054948.22753-1-vladimir@nikishkin.pw>
 <ZGpvrV4FGjBvqVjg@shredder> <20230521124741.3bb2904c@hermes.local>
 <ZGsIhkGT4RBUTS+F@shredder> <20230522083216.09cc8fd7@hermes.local>
 <ZGyJ1r+A3zIhmk0/@renaissance-vector>
User-agent: mu4e 1.8.14; emacs 30.0.50
From: Vladimir Nikishkin <vladimir@nikishkin.pw>
To: Andrea Claudi <aclaudi@redhat.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>, Ido Schimmel
 <idosch@idosch.org>, dsahern@gmail.com, netdev@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
 razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
 eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v5] ip-link: add support for nolocalbypass
 in vxlan
Date: Tue, 23 May 2023 17:52:30 +0800
In-reply-to: <ZGyJ1r+A3zIhmk0/@renaissance-vector>
Message-ID: <875y8je5er.fsf@laptop.lockywolf.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Andrea Claudi <aclaudi@redhat.com> writes:

> On Mon, May 22, 2023 at 08:32:16AM -0700, Stephen Hemminger wrote:
>> On Mon, 22 May 2023 09:15:34 +0300
>> Ido Schimmel <idosch@idosch.org> wrote:
>> 
>> > On Sun, May 21, 2023 at 12:47:41PM -0700, Stephen Hemminger wrote:
>> > > On Sun, 21 May 2023 22:23:25 +0300
>> > > Ido Schimmel <idosch@idosch.org> wrote:
>> > >   
>> > > > +       if (tb[IFLA_VXLAN_LOCALBYPASS])
>> > > > +               print_bool(PRINT_ANY, "localbypass", "localbypass ",
>> > > > +                          rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]))  
>> > > 
>> > > That will not work for non json case.  It will print localbypass whether it is set or not.
>> > > The third argument is a format string used in the print routine.  
>> > 
>> > Yea, replied too late...
>> > 
>> > Anyway, my main problem is with the JSON output. Looking at other
>> > boolean VXLAN options, we have at least 3 different formats:
>> > 
>> > 1. Only print when "true" for both JSON and non-JSON output. Used for
>> > "external", "vnifilter", "proxy", "rsc", "l2miss", "l3miss",
>> > "remcsum_tx", "remcsum_rx".
>> > 
>> > 2. Print when both "true" and "false" for both JSON and non-JSON output.
>> > Used for "udp_csum", "udp_zero_csum6_tx", "udp_zero_csum6_rx".
>> > 
>> > 3. Print JSON when both "true" and "false" and non-JSON only when
>> > "false". Used for "learning".
>> > 
>> > I don't think we should be adding another format. We need to decide:
>> > 
>> > 1. What is the canonical format going forward?
>> > 
>> > 2. Do we change the format of existing options?
>> > 
>> > My preference is:
>> > 
>> > 1. Format 2. Can be implemented in a common helper used for all VXLAN
>> > options.
>> > 
>> > 2. Yes. It makes all the boolean options consistent and avoids future
>> > discussions such as this where a random option is used for a new option.
>> 
>> A fourth option is to us print_null(). The term null is confusing and people
>> seem to avoid it.  But it is often used by python programmers as way to represent
>> options. That would be my preferred option but others seem to disagree.
>> 
>> Option #2 is no good. Any printing of true/false in non-JSON output is a diveregence
>> from the most common practice across iproute2.
>> 
>> That leaves #3 as the correct and best output.
>> 
>> FYI - The iproute2 maintainers are David Ahern and me. The kernel bits have
>> other subsystem maintainers.
>> 
>
> Just to make sure I understand correctly, this means we are printing
> "nolocalbypass" in non-JSON output because it's the non-default
> settings, right?
>
> If this is correct, then if we have another option in the future that
> comes disabled by default, this means we are going to print it in
> non-JSON output when enabled.
>
> As the primary consumer of non-JSON output are humans, I am a bit
> concerned since a succession of enabled/noenabled options is awkward and
> difficult to read, in my opinion.
>
> Wouldn't it be better to have non-JSON print out options only when
> enabled, regardless of their default value?

Sorry, what is "enabled" and what is "disabled by default"?
I think this is a major source of confusion.

If the option is "nolocalbypass", it is "disabled by default".
If the option is "localbypass", it is "enabled by default".

Intuitively, it seems that everything that is "default" should be
considered disabled, hence the actual option is "nolocalbypass", an by
default it is disabled, and hence not printed. Its opposite requires
explicitly adding a command-line parameter, and hence the "enabled"
state is "nolocalbypass". I think this is the logic that Stephen is
proposing.


-- 
Your sincerely,
Vladimir Nikishkin (MiEr, lockywolf)
(Laptop)
--
Fastmail.



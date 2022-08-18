Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77D8597F53
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 09:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243752AbiHRHhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 03:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiHRHhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 03:37:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BFFA3472;
        Thu, 18 Aug 2022 00:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=HYs0ufAt7cQqAQMzoqBHFMeAW4UaG1L50QDWW/7yISg=;
        t=1660808224; x=1662017824; b=oFcQGUhzb3+c5MnKktutHWP8Z0PUKr8aTC2v4zRE66PbU7W
        HM0Uhm7gOAkeF2jGcHdAi/oSocHPWV4nxOi0pH1Gl5Obc/WmzOZCRiPLabeFeN+NxX69d71iH4iKh
        cZs2AB72jdGJUl9Cx6qdYzvJ/KOM/Oi4rScp22ToLduJRqQk4uhfLVh9GYaVTTDbHbvm8nMGsZJH+
        TJE0uotu2ANp4g0U2h4DnMytM8MxKwSqd3rixP+9vtoPoQhNDYsqJkXzksqK4r9bOER+h+7GJbDz6
        MYXsMWwAiwjkW4/jCPQpClsktRhYnE5il7TxEPQJyPj8gWqgVuDbmIC+HJGuo9Pg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oOa5A-00B8pc-1z;
        Thu, 18 Aug 2022 09:36:48 +0200
Message-ID: <6350516756628945f9cc1ee0248e92473521ed0b.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 2/2] docs: netlink: basic introduction to
 Netlink
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net, stephen@networkplumber.org,
        sdf@google.com, ecree.xilinx@gmail.com, benjamin.poirier@gmail.com,
        idosch@idosch.org, f.fainelli@gmail.com, jiri@resnulli.us,
        dsahern@kernel.org, fw@strlen.de, linux-doc@vger.kernel.org,
        jhs@mojatatu.com, tgraf@suug.ch, jacob.e.keller@intel.com,
        svinota.saveliev@gmail.com
Date:   Thu, 18 Aug 2022 09:36:46 +0200
In-Reply-To: <20220818023504.105565-2-kuba@kernel.org>
References: <20220818023504.105565-1-kuba@kernel.org>
         <20220818023504.105565-2-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-08-17 at 19:35 -0700, Jakub Kicinski wrote:

> +To get information about the Generic Netlink family named for example
> +``"test1"`` we need to send a message on the previously opened Generic N=
etlink
> +socket. The message should target the Generic Netlink Family (1), be a
> +``do`` (2) call to ``CTRL_CMD_GETFAMILY`` (3). A ``dump`` version of thi=
s
> +call would make the kernel respond with information about *all* the fami=
lies
> +it knows about. Last but not least the name of the family in question ha=
s
> +to be specified (4) as an attribute with the appropriate type::
> +
> +  struct nlmsghdr:
> +    __u32 nlmsg_len:	32
> +    __u16 nlmsg_type:	GENL_ID_CTRL               // (1)
> +    __u16 nlmsg_flags:	NLM_F_REQUEST | NLM_F_ACK  // (2)
> +    __u32 nlmsg_seq:	1
> +    __u32 nlmsg_pid:	0
> +
> +  struct genlmsghdr:
> +    __u8 cmd:		CTRL_CMD_GETFAMILY         // (3)
> +    __u8 version:	2 /* or 1, doesn't matter */
> +    __u16 reserved:	0
> +
> +  struct nlattr:                                   // (4)
> +    __u16 nla_len:	10
> +    __u16 nla_type:	CTRL_ATTR_FAMILY_NAME
> +    char data: 		test1\0
> +
> +  (padding:)
> +    char data:		\0\0
> +
> +The length fields in Netlink (:c:member:`nlmsghdr.nlmsg_len`
> +and :c:member:`nlattr.nla_len`) always *include* the header.
> +Headers in netlink must be aligned to 4 bytes from the start of the mess=
age,

s/Headers/Attribute headers/ perhaps?

> +hence the extra ``\0\0`` at the end of the message.
>=20

And I think technically for the _last_ attribute it wouldn't be needed?

> +If the family is found kernel will reply with two messages, the response
> +with all the information about the family::
> +
> +  /* Message #1 - reply */
> +  struct nlmsghdr:
> +    __u32 nlmsg_len:	136
> +    __u16 nlmsg_type:	GENL_ID_CTRL
> +    __u16 nlmsg_flags:	0
> +    __u32 nlmsg_seq:	1    /* echoed from our request */
> +    __u32 nlmsg_pid:	5831 /* The PID of our user space process */

s/PID/netlink port ID/

It's actually whatever you choose, I think? Lots of libraries will
choose (something based on) the process ID, but that's not really
needed?

(autobind is different maybe?)


> +  /* Message #2 - the ACK */
> +  struct nlmsghdr:
> +    __u32 nlmsg_len:	36
> +    __u16 nlmsg_type:	NLMSG_ERROR
> +    __u16 nlmsg_flags:	NLM_F_CAPPED /* There won't be a payload */
> +    __u32 nlmsg_seq:	1    /* echoed from our request */
> +    __u32 nlmsg_pid:	5831 /* The PID of our user space process */

(same here of course)

> +``NLMSGERR_ATTR_MSG`` carries a message in English describing
> +the encountered problem. These messages are far more detailed
> +than what can be expressed thru standard UNIX error codes.

"through"?

> +Querying family information is useful in rare cases when user space need=
s

debatable if that's "rare", but yeah, today it's not done much :)

> +.. _nlmsg_pid:
> +
> +nlmsg_pid
> +---------
> +
> +:c:member:`nlmsghdr.nlmsg_pid` is called PID because the protocol predat=
es
> +wide spread use of multi-threading and the initial recommendation was
> +to use process ID in this field. Process IDs start from 1 hence the use
> +of ``0`` to mean "allocate automatically".
> +
> +The field is still used today in rare cases when kernel needs to send
> +a unicast notification. User space application can use bind() to associa=
te
> +its socket with a specific PID (similarly to binding to a UDP port),
> +it then communicates its PID to the kernel.
> +The kernel can now reach the user space process.
> +
> +This sort of communication is utilized in UMH (user mode helper)-like
> +scenarios when kernel needs to trigger user space logic or ask user
> +space for a policy decision.
> +
> +Kernel will automatically fill the field with process ID when responding
> +to a request sent with the :c:member:`nlmsghdr.nlmsg_pid` value of ``0``=
.


I think this could be written a bit better - we call this thing a "port
ID" internally now, and yes, it might default to a process ID (more
specifically task group ID) ... but it feels like this could explain
bind vs. autobind etc. a bit more? And IMHO it should focus less on the
process ID/PID than saying "port ID" with a (historical) default of
using the PID/TGID.

> +Strict checking
> +---------------
> +
> +The ``NETLINK_GET_STRICT_CHK`` socket option enables strict input checki=
ng
> +in ``NETLINK_ROUTE``. It was needed because historically kernel did not
> +validate the fields of structures it didn't process. This made it imposs=
ible
> +to start using those fields later without risking regressions in applica=
tions
> +which initialized them incorrectly or not at all.
> +
> +``NETLINK_GET_STRICT_CHK`` declares that the application is initializing
> +all fields correctly. It also opts into validating that message does not
> +contain trailing data and requests that kernel rejects attributes with
> +type higher than largest attribute type known to the kernel.
> +
> +``NETLINK_GET_STRICT_CHK`` is not used outside of ``NETLINK_ROUTE``.

However, there are also more generally strict checks in policy
validation ... maybe a discussion of all that would be worthwhile?

> +Unknown attributes
> +------------------
> +
> +Historically Netlink ignored all unknown attributes. The thinking was th=
at
> +it would free the application from having to probe what kernel supports.
> +The application could make a request to change the state and check which
> +parts of the request "stuck".
> +
> +This is no longer the case for new Generic Netlink families and those op=
ting
> +in to strict checking. See enum netlink_validation for validation types
> +performed.

OK some of that is this, but some of it is also the strict length checks
e.g. for Ethernet addresses.

> +Fixed metadata and structures
> +-----------------------------
> +
> +Classic Netlink made liberal use of fixed-format structures within
> +the messages. Messages would commonly have a structure with
> +a considerable number of fields after struct nlmsghdr. It was also
> +common to put structures with multiple members inside attributes,
> +without breaking each member into an attribute of its own.

That reads very descriptive and historic without making a recommendation
- I know it's in the section, but maybe do say something like "This is
discouraged now and attributes should be used instead"?


Either way, thanks for doing this, it's a great overview!

We might add:
 - availability of attribute policy introspection
   (you mention family introspection only I think)

 - do we want to bring in the whole "per operation" vs. "per genetlink
   family" attribute policy?
   (I'm firmly on the "single policy for the whole family" side ...)

 - maybe not the appropriate place here, but maybe some best practices
   for handling attributes, such as the multi-attribute array thing we
   discussed in the other thread?

 - maybe more userspace recommendations such as using different sockets
   for multicast listeners and requests, because otherwise it gets
   tricky to wait for the ACK of a request since you have to handle
   notifications that happen meanwhile?

 - maybe some mention of the fact that sometimes we now bind kernel
   object or state lifetime to a socket, e.g. in wireless you can
   connect and if your userspace crashes/closes the socket, the
   connection is automatically torn down (because you can't handle the
   things needed anymore)

 - maybe something about message sizes? we've had lots of trouble with
   that in nl80211, but tbh I'm not really sure what we should say about
   it other than making sure you use large enough buffers ...

johannes

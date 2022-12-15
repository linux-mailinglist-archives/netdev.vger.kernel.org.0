Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0043364E4E4
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 00:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiLOX6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 18:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLOX6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 18:58:40 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B149A5EDD8;
        Thu, 15 Dec 2022 15:58:39 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C196D5C0159;
        Thu, 15 Dec 2022 18:58:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 15 Dec 2022 18:58:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1671148716; x=1671235116; bh=e2HI79rwOs
        1ErWv+7CQleqWbWW0/+VxHQoBKyeWmUxc=; b=cgj+JW/Bq8ptwzAfU2gBF/tHz8
        rWivZuY3sRCybsu+zGxU6iSLwezH/qJir42FM+D0cFvkY/zyXu7xXR74rJQy7NCK
        U20Zx1dxEbm/hSyXRxwzQTmd5CAj29QtE+7oS5pdF++l9i/Hq+PUwWdMrHYx9Y3D
        jzcQjU/7oLCWwQuf2X06dUIyJnhUc8AT5ElliR6QNn9odnp0TnCGC5VrptMJQuFC
        4sGWCGQs8IJ/Qe2KptjC2Ivf8Dkl3aJoZ2jlXWIIQUXZAqKSKW+ugVjkkvCHnIDW
        dUHplVgAQ+s6frkR85NIpkEC6JqE0mzWwfXGcRtZ/ssczAYDTkLt3muPElNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1671148716; x=1671235116; bh=e2HI79rwOs1ErWv+7CQleqWbWW0/
        +VxHQoBKyeWmUxc=; b=XcfkXf8xqOssFvwfgekugaVD8m3czXDJ6Cks8GwZtR8s
        5gq7nnexUyCu5Frh0bnhK7t7t2s5tPcLLUqy1cj+v7F4bZXsGm7zdm9jQJW7uKgR
        Lld84GOWDRtdXRA7kvl6V/GA47bInt4WsqD3pzd02h6fbxQsWHmL+H+SJYDOokHy
        sD2BTgRAM5p1WxQquK7W9W8D0CHvtxcvzE7hHxfqdGBY/pXlYxUUH6Vq3JQoRBSn
        whbym5Umr+Ve5aEDahWMTZO5kFMVCItpU7mkHe8TSsyRLEnmIcJBlMD2ewlGf4c4
        JJSIwOAzW56jLqxKi/8tHkqxBOuMPSF4DwXZIj9JAQ==
X-ME-Sender: <xms:rLSbY8NES9EEFg9U9c9ln_pUnrQEby7YW2TDddbrkcZ9oQpIoaeIBg>
    <xme:rLSbYy-VjYIqTRlaN6nXDomp3pQXPrNXYPx6_rFtYmpT9JJY9Oa8L7d7zuBc41z1t
    kjve96yec-N-QpkQQ>
X-ME-Received: <xmr:rLSbYzQXBQvrt0BoBJKQnzXVz-Jnx1IbVYX-CgnXa9R3eM5pNQQ3J10NOJkwiV04w8hyJrwo6opObE43mDrpksY8gQQm4hm5yYwa>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeigddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdefhedmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddt
    vdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqeenuc
    ggtffrrghtthgvrhhnpeffffdvfefhudfhfeejjedvieduiefgvdfghfejkeehueeuhfdv
    ieeftdeugfffhfenucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiih
    ii
X-ME-Proxy: <xmx:rLSbY0sF1wSi1b6MUXOsJcTczlEQ6wNBzBkNAtPn9j90I2wY6fpf0A>
    <xmx:rLSbY0dntmVHvmk_Mc0uQWYuKwp9PJ15_MfWOmMIHZFdXGR22jTPiQ>
    <xmx:rLSbY41fzncozS3E6YmRlM6FbMLw3XxbNnR7zwbwE2CJM_GLcs89AA>
    <xmx:rLSbY1VZsTwARLJrVrW-pRvDAquxB9DmbThdIdmh-k_I4-4nT7ndgQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Dec 2022 18:58:35 -0500 (EST)
Date:   Thu, 15 Dec 2022 16:58:33 -0700
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ppenkov@aviatrix.com,
        dbird@aviatrix.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 3/6] bpf, net, frags: Add bpf_ip_check_defrag()
 kfunc
Message-ID: <20221215235833.bxydbz4irmri7bsw@kashmir.localdomain>
References: <cover.1671049840.git.dxu@dxuuu.xyz>
 <1f48a340a898c4d22d65e0e445dbf15f72081b9a.1671049840.git.dxu@dxuuu.xyz>
 <451b291a-7798-cfe2-84da-815937b54f70@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <451b291a-7798-cfe2-84da-815937b54f70@iogearbox.net>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Thanks for taking a look!

On Thu, Dec 15, 2022 at 11:31:52PM +0100, Daniel Borkmann wrote:
> Hi Daniel,
> 
> Thanks for working on this!
> 
> On 12/15/22 12:25 AM, Daniel Xu wrote:
> [...]
> > +#include <linux/bpf.h>
> > +#include <linux/btf_ids.h>
> > +#include <linux/ip.h>
> > +#include <linux/filter.h>
> > +#include <linux/netdevice.h>
> > +#include <net/ip.h>
> > +#include <net/sock.h>
> > +
> > +__diag_push();
> > +__diag_ignore_all("-Wmissing-prototypes",
> > +		  "Global functions as their definitions will be in ip_fragment BTF");
> > +
> > +/* bpf_ip_check_defrag - Defragment an ipv4 packet
> > + *
> > + * This helper takes an skb as input. If this skb successfully reassembles
> > + * the original packet, the skb is updated to contain the original, reassembled
> > + * packet.
> > + *
> > + * Otherwise (on error or incomplete reassembly), the input skb remains
> > + * unmodified.
> > + *
> > + * Parameters:
> > + * @ctx		- Pointer to program context (skb)
> > + * @netns	- Child network namespace id. If value is a negative signed
> > + *		  32-bit integer, the netns of the device in the skb is used.
> > + *
> > + * Return:
> > + * 0 on successfully reassembly or non-fragmented packet. Negative value on
> > + * error or incomplete reassembly.
> > + */
> > +int bpf_ip_check_defrag(struct __sk_buff *ctx, u64 netns)
> 
> small nit: for sk lookup helper we've used u32 netns_id, would be nice to have
> this consistent here as well.

Hmm, when I grep I see the sk lookup helpers using a u64 as well:

        $ rg "u64 netns" ./include/uapi/linux/bpf.h
        3394: * struct bpf_sock *bpf_sk_lookup_tcp(void *ctx, struct bpf_sock_tuple *tuple, u32 tuple_size, u64 netns, u64 flags)
        3431: * struct bpf_sock *bpf_sk_lookup_udp(void *ctx, struct bpf_sock_tuple *tuple, u32 tuple_size, u64 netns, u64 flags)
        3629: * struct bpf_sock *bpf_skc_lookup_tcp(void *ctx, struct bpf_sock_tuple *tuple, u32 tuple_size, u64 netns, u64 flags)
        6238:   __u64 netns_dev;
        6239:   __u64 netns_ino;
        6274:   __u64 netns_dev;
        6275:   __u64 netns_ino;
        $ rg "u32 netns" ./include/uapi/linux/bpf.h
        6335:                   __u32 netns_ino;

Am I looking at the right place?

> 
> > +{
> > +	struct sk_buff *skb = (struct sk_buff *)ctx;
> > +	struct sk_buff *skb_cpy, *skb_out;
> > +	struct net *caller_net;
> > +	struct net *net;
> > +	int mac_len;
> > +	void *mac;
> > +
> > +	if (unlikely(!((s32)netns < 0 || netns <= S32_MAX)))
> > +		return -EINVAL;
> > +
> > +	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
> > +	if ((s32)netns < 0) {
> > +		net = caller_net;
> > +	} else {
> > +		net = get_net_ns_by_id(caller_net, netns);
> > +		if (unlikely(!net))
> > +			return -EINVAL;
> > +	}
> > +
> > +	mac_len = skb->mac_len;
> > +	skb_cpy = skb_copy(skb, GFP_ATOMIC);
> > +	if (!skb_cpy)
> > +		return -ENOMEM;
> 
> Given slow path, this idea is expensive but okay. Maybe in future it could be lifted
> which might be a bigger lift to teach verifier that input ctx cannot be accessed
> anymore.. but then frags are very much discouraged either way and bpf_ip_check_defrag()
> might only apply in corner case situations (like DNS, etc).

Originally I did go the route of teaching the verifier:

* https://github.com/danobi/linux/commit/35a66af8d54cca647b0adfc7c1da7105d2603dde
* https://github.com/danobi/linux/commit/e8c86ea75e2ca8f0631632d54ef763381308711e
* https://github.com/danobi/linux/commit/972bcf769f41fbfa7f84ce00faf06b5b57bc6f7a

It didn't seem too bad on the verifier front (or maybe I got it wrong),
but it seemed a bit unwieldy to wire ctx validity information back out
of the program given ip_check_defrag() may kfree() the skb (so stuffing
data inside skb->cb wouldn't work).

And yeah, given frags are highly discouraged, didn't seem like too bad
of a tradeoff.

> 
> > +	skb_out = ip_check_defrag(net, skb_cpy, IP_DEFRAG_BPF);
> > +	if (IS_ERR(skb_out))
> > +		return PTR_ERR(skb_out);
> 
> Looks like ip_check_defrag() can gracefully handle IPv6 packet. It will just return back
> skb_cpy pointer in that case. However, this brings me to my main complaint.. I don't
> think we should merge anything IPv4-related without also having IPv6 equivalent support,
> otherwise we're building up tech debt, so pls also add support for the latter.

Ok, I'll take a crack at ipv6 support too. Most likely in the form of
another kfunc, depending on how the ipv6 frag infra is set up.

I'll be in and out during the holidays so v2 will most likely come some
time in the new year.

[...]

Thanks,
Daniel

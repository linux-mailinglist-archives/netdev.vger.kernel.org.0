Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51BC1699549
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 14:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjBPNNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 08:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjBPNM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 08:12:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C4E4DE12
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676553136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/A0uZg4oY2NZm42iz/nwkBxXAZ2WK2mP7XLmREVYbY0=;
        b=VC+gcr3mJO4HEjGTl+rXeknba16SIs9mpnjycGvTo/SlQrKxOSNeSQowFX1s+JHsH3DUMI
        lyk996JrIT8Wrn1i4El6Wkz/ko35ZTshYavYvt7YiPMkDURaqC4IvgmlWAyXp+dLbTDOBV
        HD8UX0bciyIvK/nGPIJC+c/58rKZ1QA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-185-o6L-oUp9NIauUANT70H-sQ-1; Thu, 16 Feb 2023 08:12:14 -0500
X-MC-Unique: o6L-oUp9NIauUANT70H-sQ-1
Received: by mail-qv1-f69.google.com with SMTP id ng1-20020a0562143bc100b004bb706b3a27so1031492qvb.20
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:12:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/A0uZg4oY2NZm42iz/nwkBxXAZ2WK2mP7XLmREVYbY0=;
        b=Atlh46mBRtHAWRKHi+2MIdU/arJdH/n+xOdYjPsoWdcxuebzqLKpnI/9iGsJi6cfQQ
         Wa3KqJcm1uCmR/KPGzTRjHVQBYy+KvhPc5WEzhbkVVeso5XpEdIEsGxh4cct4j9/ziJQ
         WKIIut/DtbOg8GsSGxFSgS6PsHsML3yY1nNLCjYhmrrc8uJhJuquVgKXYsggQLMgF/AM
         6sJ4NKjh0MIevG1kJ8GAcek4VzfAcgLY4HC99qkEKmBp8LHb+P3WAI7GiXKD+yC3U3BT
         mBSuj8KfbD43Lac6du/KhZS68GrV77yWyO5sG1AWQu25Cr+husWixRfX5Xg0ssr1WB95
         FEzQ==
X-Gm-Message-State: AO0yUKVPmYfxi2L7pdzNWMU/zd2nTPVwVhDajuEbeLbENp+1wsYT0Kv1
        Sy5heEaz69xc3e15PM6pej6OpDSIeryNqIWWUYrEkyHhuM6swqYv2Ev58kSIi6utPNJ+gTKiIoU
        yp793ItZEtyHOFceB
X-Received: by 2002:a05:622a:178e:b0:3b9:fc92:a6 with SMTP id s14-20020a05622a178e00b003b9fc9200a6mr10725888qtk.6.1676553133414;
        Thu, 16 Feb 2023 05:12:13 -0800 (PST)
X-Google-Smtp-Source: AK7set8DMCAi8W4CPnarY+SYt9fo91U+F1hOhEj01V1T35Hi0FQuQYu2UU+5fXTnucOP/CJcfKRcew==
X-Received: by 2002:a05:622a:178e:b0:3b9:fc92:a6 with SMTP id s14-20020a05622a178e00b003b9fc9200a6mr10725853qtk.6.1676553133052;
        Thu, 16 Feb 2023 05:12:13 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id g17-20020ac842d1000000b003b8558eabd0sm1206128qtm.23.2023.02.16.05.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 05:12:12 -0800 (PST)
Message-ID: <df1c06c2a2b516e4adb5d74cf1f50935e745abdc.camel@redhat.com>
Subject: Re: [PATCH v4 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
From:   Paolo Abeni <pabeni@redhat.com>
To:     Chuck Lever <chuck.lever@oracle.com>, kuba@kernel.org,
        edumazet@google.com
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        bcodding@redhat.com, kolga@netapp.com, jmeneghi@redhat.com
Date:   Thu, 16 Feb 2023 14:12:08 +0100
In-Reply-To: <167648899461.5586.1581702417186195077.stgit@91.116.238.104.host.secureserver.net>
References: <167648817566.5586.11847329328944648217.stgit@91.116.238.104.host.secureserver.net>
         <167648899461.5586.1581702417186195077.stgit@91.116.238.104.host.secureserver.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[partial feedback /me is still a bit lost in the code ;]
On Wed, 2023-02-15 at 14:23 -0500, Chuck Lever wrote:
> +/*
> + * This function is careful to not close the socket. It merely removes
> + * it from the file descriptor table so that it is no longer visible
> + * to the calling process.
> + */
> +static int handshake_genl_cmd_done(struct sk_buff *skb, struct genl_info=
 *gi)
> +{
> +	struct nlattr *tb[HANDSHAKE_GENL_ATTR_MAX + 1];
> +	struct handshake_req *req;
> +	struct socket *sock;
> +	int fd, status, err;
> +
> +	err =3D genlmsg_parse(nlmsg_hdr(skb), &handshake_genl_family, tb,
> +			    HANDSHAKE_GENL_ATTR_MAX, handshake_genl_policy,
> +			    NULL);
> +	if (err) {
> +		pr_err_ratelimited("%s: genlmsg_parse() returned %d\n",
> +				   __func__, err);
> +		return err;
> +	}
> +
> +	if (!tb[HANDSHAKE_GENL_ATTR_SOCKFD])
> +		return handshake_genl_status_reply(skb, gi, -EINVAL);
> +	err =3D 0;
> +	fd =3D nla_get_u32(tb[HANDSHAKE_GENL_ATTR_SOCKFD]);
> +	sock =3D sockfd_lookup(fd, &err);
> +	if (err)
> +		return handshake_genl_status_reply(skb, gi, -EBADF);
> +
> +	req =3D sock->sk->sk_handshake_req;
> +	if (req->hr_fd !=3D fd)	/* sanity */
> +		return handshake_genl_status_reply(skb, gi, -EBADF);
> +
> +	status =3D -EIO;
> +	if (tb[HANDSHAKE_GENL_ATTR_SESS_STATUS])
> +		status =3D nla_get_u32(tb[HANDSHAKE_GENL_ATTR_SESS_STATUS]);
> +
> +	put_unused_fd(req->hr_fd);

If I read correctly, at this point the user-space is expected to have
already closed hr_fd , but that is not enforced, right? a buggy or
malicious user-space could cause bad things not closing such fd.

Can we use=C2=A0sockfd_put(sock) instead? will make the code more readable,
I think.

BTW I don't think there is any problem with the sock->sk dereference
above, the fd reference count will prevent __sock_release from being
called.

[...]

> +static void __net_exit handshake_net_exit(struct net *net)
> +{
> +	struct handshake_req *req;
> +	LIST_HEAD(requests);
> +
> +	/*
> +	 * XXX: This drains the net's pending list, but does
> +	 *	nothing about requests that have been accepted
> +	 *	and are in progress.
> +	 */
> +	spin_lock(&net->hs_lock);
> +	list_splice_init(&requests, &net->hs_requests);
> +	spin_unlock(&net->hs_lock);

If I read correctly accepted, uncompleted reqs are leaked. I think that
could be prevented installing a custom sk_destructor in sock->sk
tacking care of freeing the sk->sk_handshake_req. The existing/old
sk_destructor - if any - could be stored in an additional
sk_handshake_req field and tail-called by the req's one.

[...]

> +/*
> + * This limit is to prevent slow remotes from causing denial of service.
> + * A ulimit-style tunable might be used instead.
> + */
> +#define HANDSHAKE_PENDING_MAX (10)

I liked the idea of a core mem based limit ;) not a big deal anyway ;)

> +
> +struct handshake_req *handshake_req_get(struct handshake_req *req)
> +{
> +	return likely(refcount_inc_not_zero(&req->hr_ref)) ? req : NULL;
> +}

It's unclear to me under which circumstances the refcount should be >
1: AFAICS the req should have always a single owner: initially the
creator, then the accept queue and finally the user-space serving the
request.

Cheers,

Paolo


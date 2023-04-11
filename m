Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61FA6DD38C
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 08:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjDKG67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 02:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjDKG65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 02:58:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A5B172C;
        Mon, 10 Apr 2023 23:58:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BEA6421A48;
        Tue, 11 Apr 2023 06:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681196334; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FWRIpt3u2RkZ57l/yE6etWt/OArtq4m6SrxMv/Sixoo=;
        b=jPw3SUMbIeOfsgMUAhHRBlfMTVNZAkrPi9kefqCLiyk8/mDHPzmsDtonYKDFYD41GJ3khK
        U6CRd0hfRIcec4PGxSVAr4HksLIqTJgAAOeDenKC5s7SGSx7wo92VfRWBFQsjeNxEEBWu0
        X7n5sFAbGFMIBR6WC1NT/drCeYHEoMQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681196334;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FWRIpt3u2RkZ57l/yE6etWt/OArtq4m6SrxMv/Sixoo=;
        b=5qCCkeKWD50jVRVhe8uQ0KDn865KuKWYuF8G2zC3vwQAzK9Rj2K8BsZNLKG5EkKcNU5Ybb
        HunDZGRl5N6/aSCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 92E8B13519;
        Tue, 11 Apr 2023 06:58:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yGqtIS4FNWSGVgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 06:58:54 +0000
Message-ID: <b3cad686-fa03-b7a4-01c3-9293a7421582@suse.de>
Date:   Tue, 11 Apr 2023 08:58:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [RFC PATCH 5/9] iscsi: set netns for iscsi_tcp hosts
Content-Language: en-US
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org,
        Lee Duncan <lduncan@suse.com>
References: <cover.1675876731.git.lduncan@suse.com>
 <566c527d12f6ed56eeb40952fef7431a0ccdc78f.1675876735.git.lduncan@suse.com>
 <82eb95ac-2dca-7a7a-116a-2771c4551bab@suse.de> <ZDSoH193jm2jOZKA@localhost>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <ZDSoH193jm2jOZKA@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/23 02:21, Chris Leech wrote:
> On Tue, Mar 14, 2023 at 05:29:25PM +0100, Hannes Reinecke wrote:
>> On 2/8/23 18:40, Lee Duncan wrote:
>>> From: Lee Duncan <lduncan@suse.com>
>>>
>>> This lets iscsi_tcp operate in multiple namespaces.  It uses current
>>> during session creation to find the net namespace, but it might be
>>> better to manage to pass it along from the iscsi netlink socket.
>>>
>> And indeed, I'd rather use the namespace from the iscsi netlink socket.
>> If you use the namespace from session creation you'd better hope that
>> this function is not called from a workqueue ...
> 
> The cleanest way I see to do this is to split the transport
> session_create function between bound and unbound, instead of checking
> for a NULL ep.  That should cleanly serperate out the host-per-session
> behavior of iscsi_tcp, so we can pass in the namespace without changing
> the other drivers.
> 
> This is what that looks like on top of the existing patches, but we can
> merge it in and rearrange if desired.
> 
> - Chris
> 
> ---
> 
> Distinguish between bound and unbound session creation with different
> transport functions, instead of just checking for a NULL endpoint.
> 
> This let's the transport code pass the network namespace into the
> unbound session creation of iscsi_tcp, without changing the offloading
> drivers which all expect an bound endpoint.
> 
> iSER has compatibility checks to work without a bound endpoint, so
> expose both transport functions there.
> 
> Signed-off-by: Chris Leech <cleech@redhat.com>
> ---
>   drivers/infiniband/ulp/iser/iscsi_iser.c | 41 +++++++++++++++++-------
>   drivers/scsi/iscsi_tcp.c                 | 16 ++++-----
>   drivers/scsi/iscsi_tcp.h                 |  1 +
>   drivers/scsi/scsi_transport_iscsi.c      | 17 +++++++---
>   include/scsi/scsi_transport_iscsi.h      |  3 ++
>   5 files changed, 52 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 6865f62eb831..ca8de612d585 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -593,20 +593,10 @@ static inline unsigned int iser_dif_prot_caps(int prot_caps)
>   	return ret;
>   }
>   
> -/**
> - * iscsi_iser_session_create() - create an iscsi-iser session
> - * @ep:             iscsi end-point handle
> - * @cmds_max:       maximum commands in this session
> - * @qdepth:         session command queue depth
> - * @initial_cmdsn:  initiator command sequnce number
> - *
> - * Allocates and adds a scsi host, expose DIF supprot if
> - * exists, and sets up an iscsi session.
> - */
>   static struct iscsi_cls_session *
> -iscsi_iser_session_create(struct iscsi_endpoint *ep,
> +__iscsi_iser_session_create(struct iscsi_endpoint *ep,
>   			  uint16_t cmds_max, uint16_t qdepth,
> -			  uint32_t initial_cmdsn)
> +			  uint32_t initial_cmdsn, struct net *net)
>   {
>   	struct iscsi_cls_session *cls_session;
>   	struct Scsi_Host *shost;
> @@ -694,6 +684,32 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
>   	return NULL;
>   }
>   
> +/**
> + * iscsi_iser_session_create() - create an iscsi-iser session
> + * @ep:             iscsi end-point handle
> + * @cmds_max:       maximum commands in this session
> + * @qdepth:         session command queue depth
> + * @initial_cmdsn:  initiator command sequnce number
> + *
> + * Allocates and adds a scsi host, expose DIF supprot if
> + * exists, and sets up an iscsi session.
> + */
> +static struct iscsi_cls_session *
> +iscsi_iser_session_create(struct iscsi_endpoint *ep,
> +			  uint16_t cmds_max, uint16_t qdepth,
> +			  uint32_t initial_cmdsn) {
> +	return __iscsi_iser_session_create(ep, cmds_max, qdepth,
> +					   initial_cmdsn, NULL);
> +}
> +
> +static struct iscsi_cls_session *
> +iscsi_iser_unbound_session_create(struct net *net,
> +				  uint16_t cmds_max, uint16_t qdepth,
> +				  uint32_t initial_cmdsn) {
> +	return __iscsi_iser_session_create(NULL, cmds_max, qdepth,
> +					   initial_cmdsn, net);
> +}
> +
>   static int iscsi_iser_set_param(struct iscsi_cls_conn *cls_conn,
>   				enum iscsi_param param, char *buf, int buflen)
>   {
> @@ -983,6 +999,7 @@ static struct iscsi_transport iscsi_iser_transport = {
>   	.caps                   = CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_TEXT_NEGO,
>   	/* session management */
>   	.create_session         = iscsi_iser_session_create,
> +	.create_unbound_session = iscsi_iser_unbound_session_create,
>   	.destroy_session        = iscsi_iser_session_destroy,
>   	/* connection management */
>   	.create_conn            = iscsi_iser_conn_create,
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 171685011ad9..b78239f25073 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -922,7 +922,7 @@ iscsi_sw_tcp_conn_get_stats(struct iscsi_cls_conn *cls_conn,
>   }
>   
>   static struct iscsi_cls_session *
> -iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
> +iscsi_sw_tcp_session_create(struct net *net, uint16_t cmds_max,
>   			    uint16_t qdepth, uint32_t initial_cmdsn)
>   {
>   	struct iscsi_cls_session *cls_session;
> @@ -931,11 +931,6 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
>   	struct Scsi_Host *shost;
>   	int rc;
>   
> -	if (ep) {
> -		printk(KERN_ERR "iscsi_tcp: invalid ep %p.\n", ep);
> -		return NULL;
> -	}
> -
>   	shost = iscsi_host_alloc(&iscsi_sw_tcp_sht,
>   				 sizeof(struct iscsi_sw_tcp_host), 1);
>   	if (!shost)
> @@ -952,6 +947,9 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
>   		goto free_host;
>   	shost->can_queue = rc;
>   
> +	tcp_sw_host = iscsi_host_priv(shost);
> +	tcp_sw_host->net_ns = net;
> +
>   	if (iscsi_host_add(shost, NULL))
>   		goto free_host;
>   
> @@ -968,7 +966,6 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
>   		goto remove_session;
>   
>   	/* We are now fully setup so expose the session to sysfs. */
> -	tcp_sw_host = iscsi_host_priv(shost);
>   	tcp_sw_host->session = session;
>   	return cls_session;
>   
> @@ -1074,7 +1071,8 @@ static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
>   
>   static struct net *iscsi_sw_tcp_netns(struct Scsi_Host *shost)
>   {
> -	return current->nsproxy->net_ns;
> +	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(shost);
> +	return tcp_sw_host->net_ns;
>   }
>   
>   static struct scsi_host_template iscsi_sw_tcp_sht = {
> @@ -1104,7 +1102,7 @@ static struct iscsi_transport iscsi_sw_tcp_transport = {
>   	.caps			= CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_HDRDGST
>   				  | CAP_DATADGST,
>   	/* session management */
> -	.create_session		= iscsi_sw_tcp_session_create,
> +	.create_unbound_session	= iscsi_sw_tcp_session_create,
>   	.destroy_session	= iscsi_sw_tcp_session_destroy,
>   	/* connection management */
>   	.create_conn		= iscsi_sw_tcp_conn_create,
> diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
> index 68e14a344904..f0020cb22f59 100644
> --- a/drivers/scsi/iscsi_tcp.h
> +++ b/drivers/scsi/iscsi_tcp.h
> @@ -53,6 +53,7 @@ struct iscsi_sw_tcp_conn {
>   
>   struct iscsi_sw_tcp_host {
>   	struct iscsi_session	*session;
> +	struct net *net_ns;
>   };
>   
>   struct iscsi_sw_tcp_hdrbuf {
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 8fafa8f0e0df..4d346e79468e 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -3144,14 +3144,21 @@ static int
>   iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_endpoint *ep,
>   			struct iscsi_uevent *ev, pid_t pid,
>   			uint32_t initial_cmdsn,	uint16_t cmds_max,
> -			uint16_t queue_depth)
> +			uint16_t queue_depth, struct net *net)
>   {
>   	struct iscsi_transport *transport = priv->iscsi_transport;
>   	struct iscsi_cls_session *session;
>   	struct Scsi_Host *shost;
>   
> -	session = transport->create_session(ep, cmds_max, queue_depth,
> -					    initial_cmdsn);
> +	if (ep) {
> +		session = transport->create_session(ep, cmds_max, queue_depth,
> +						    initial_cmdsn);
> +	} else {
> +		session = transport->create_unbound_session(net, cmds_max,
> +							    queue_depth,
> +							    initial_cmdsn);
> +	}
> +
>   	if (!session)
>   		return -ENOMEM;
>   
> @@ -4145,7 +4152,7 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
>   					      portid,
>   					      ev->u.c_session.initial_cmdsn,
>   					      ev->u.c_session.cmds_max,
> -					      ev->u.c_session.queue_depth);
> +					      ev->u.c_session.queue_depth, net);
>   		break;
>   	/* MARK */
>   	case ISCSI_UEVENT_CREATE_BOUND_SESSION:
> @@ -4160,7 +4167,7 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
>   					portid,
>   					ev->u.c_bound_session.initial_cmdsn,
>   					ev->u.c_bound_session.cmds_max,
> -					ev->u.c_bound_session.queue_depth);
> +					ev->u.c_bound_session.queue_depth, net);
>   		iscsi_put_endpoint(ep);
>   		break;
>   	case ISCSI_UEVENT_DESTROY_SESSION:
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index 0c3fd690ecf8..4d8a3d770bed 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -79,6 +79,9 @@ struct iscsi_transport {
>   	struct iscsi_cls_session *(*create_session) (struct iscsi_endpoint *ep,
>   					uint16_t cmds_max, uint16_t qdepth,
>   					uint32_t sn);
> +	struct iscsi_cls_session *(*create_unbound_session) (struct net *net,
> +					uint16_t cmds_max, uint16_t qdepth,
> +					uint32_t sn);
>   	void (*destroy_session) (struct iscsi_cls_session *session);
>   	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
>   				uint32_t cid);

I'm not _that_ happy with these two functions; but can't really see a 
way around it.
Can't we rename the 'unbound' version to
'create_session_ns' or something?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman


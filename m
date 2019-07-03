Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF8C45E3D9
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 14:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfGCM0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 08:26:36 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42905 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfGCM02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 08:26:28 -0400
Received: by mail-qt1-f195.google.com with SMTP id h18so420312qtm.9;
        Wed, 03 Jul 2019 05:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T1ruVuVjiHq8kfikkrRc4v97ltAI+K9+obDRooUv2DU=;
        b=nYz5vXF/JXjKDrDtNjs8zL4z+gUkr5q13KU59uIAh1aRsinan1sbkOMxrmVHtcteDl
         6uTWKZlm7Ti4O7tjXLSgopa++ROFNKSYaeiuScFGnsqsxgX7EHU7LKVBrKHk5XpKhkWY
         6rAbFcXlkd90YEu4QQfHsvCq/mrfLUi1V7AZHJmTSWnrbjGa5NFwCmuQrY50VjUdl5XE
         Z4S31zcl/fFDvj5W3R3vEE5EAeOYVq5Laqm1RJkXa0yQMOCJx7XhhFURlewXDUbBLm+6
         sbV9CsfA/F8w4FdpZsd8AZ6zlTAASNjDl+IquTbQdmLzJ9Wwf/0QmkPAS6lSVKgP+ZVj
         Vdyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T1ruVuVjiHq8kfikkrRc4v97ltAI+K9+obDRooUv2DU=;
        b=IhjGghy8NrO/ebqYJiSzC7/EHb9TVFN+Izp/5Er7BjrtxdMz2YSOqy2AU6J+aXG2gM
         cJ0liDIrwMjMlF8ihm6P2ujZzNBJKLbbckMP8kMWPOm9OKS05Dl5oOb2SIx6TAx3rQjL
         onDk1MPt/DLq88Bg6x4Fkibh0QmascqRfiC6uBGZkeVeEU3mrLV5BieOuxaKGeqTXD7G
         /EBNmIwlkJopP/95HIAjyDZ8hhX/MxkEFYLBwrgOVH1+mMWfCOnbHB8LuMpDYlpSpkb+
         2WG/6gm0eTf9kOFCKHxpVO+e8SPCQQE1jZrSZaViljOz4GVCJlXz5qXSPARcTemQdbLw
         k6Kg==
X-Gm-Message-State: APjAAAXRYhjTZVuL35I4HBEwXwtLfsCtE28sf3TWPuDhPc+1kW0J2imH
        SczeK7Fs1EmYl4oMfQxAnSI=
X-Google-Smtp-Source: APXvYqxEXT/QYrGricC5rnUUXzZO65hcW0fShCcLu7inFcjkd2+W3M9GjKWscL9cZ6TjpBRL/qDAYA==
X-Received: by 2002:ac8:2379:: with SMTP id b54mr30933260qtb.168.1562156787282;
        Wed, 03 Jul 2019 05:26:27 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.139])
        by smtp.gmail.com with ESMTPSA id z8sm816529qki.23.2019.07.03.05.26.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 05:26:26 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id D7F41C18E9; Wed,  3 Jul 2019 09:26:23 -0300 (-03)
Date:   Wed, 3 Jul 2019 09:26:23 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: count data bundling sack chunk for
 outctrlchunks
Message-ID: <20190703122623.GC2747@localhost.localdomain>
References: <62e917e312bc582e96fa19b502561e37ca7f91a6.1562149220.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62e917e312bc582e96fa19b502561e37ca7f91a6.1562149220.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 06:20:20PM +0800, Xin Long wrote:
> Now all ctrl chunks are counted for asoc stats.octrlchunks and net
> SCTP_MIB_OUTCTRLCHUNKS either after queuing up or bundling, other
> than the chunk maked and bundled in sctp_packet_bundle_sack, which
> caused 'outctrlchunks' not consistent with 'inctrlchunks' in peer.
> 
> This issue exists since very beginning, here to fix it by increasing
> both net SCTP_MIB_OUTCTRLCHUNKS and asoc stats.octrlchunks when sack
> chunk is maked and bundled in sctp_packet_bundle_sack.
> 
> Reported-by: Ja Ram Jeon <jajeon@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/output.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index e0c2747..dbda7e7 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -282,6 +282,9 @@ static enum sctp_xmit sctp_packet_bundle_sack(struct sctp_packet *pkt,
>  					sctp_chunk_free(sack);
>  					goto out;
>  				}
> +				SCTP_INC_STATS(sock_net(asoc->base.sk),
> +					       SCTP_MIB_OUTCTRLCHUNKS);
> +				asoc->stats.octrlchunks++;
>  				asoc->peer.sack_needed = 0;
>  				if (del_timer(timer))
>  					sctp_association_put(asoc);
> -- 
> 2.1.0
> 

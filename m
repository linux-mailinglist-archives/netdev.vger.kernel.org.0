Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B9657B5F1
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbiGTLxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbiGTLxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:53:02 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1886C72BFD
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:53:00 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id a11so4566242wmq.3
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=o/9FYDVOj8aBxuVSKmyhf3uzb4f3pNgZKLHtlhhRQ3E=;
        b=xvcJAu+Qskv+1eNh9ZMVuC/HmoybiaZQ6g0E9qPMKM7uDNNcUdMhFZ6gl3tr6/TyVU
         5wX6w8hWiR/+X+IH5FX1lMNDrE/PyOkbDgefKVbez3GN19My+meGSSkibMckI3MUznCb
         TY9/uCEkFBxhVKjw73voua+wljf5P2Ht9L1Dt8gtqRhT9my0w0sA8D9UyAFQB1/X9QuK
         ct2tBvHp7QpBuFjmB26K4XKN9WIa7c995DVVzeBS2ofdcaL8oTjkd0YKUTD/VAwffSnB
         zjmkPWlIlx31YJDhVuhn4NwpG/zNzL5U7NosTwuwkyaczaqGV4j+j5oNtOrUKQVpKfIa
         AvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=o/9FYDVOj8aBxuVSKmyhf3uzb4f3pNgZKLHtlhhRQ3E=;
        b=S0zuNFkj6J2PNDyuCvwZwhqLqhP5cacBAiHZneUpWVgJHxQ7KNftXmG6sXBxWLBleK
         Xtri7+qTRoTBzrTNQjQXw/Lf67TahnXJvZfsH1r8GmS3OINQweaoNroO6ZZn9HzTyOUG
         VMbqkROsKA1TzWknzrQPuJhUuGr4uXTjIONdf3p2WumveUKyeQBYavQyWbdzwkk8I1nI
         XkQG6pl2h6mL4BwKN0QsNtL0yK+7pmvwopW5qIzBmCHKrH24y+IxskOI4qihmJJekrzD
         FsL3krfVO4SCgAfJMIGvHqrMoWzvaT0FJiKTA05qEvpZZu/M/5SAp43uWTEf2bK6jnwZ
         WkLQ==
X-Gm-Message-State: AJIora/zOijR2Ac/HKMSX6TScwoy0qHTHEmzRr5wAi9rE8QhloLTerlF
        rGOV+kG/xCZQ26fzn/dXql8Vyw==
X-Google-Smtp-Source: AGRyM1uWD+31hUS6VrnlMJFxU/T3UP2geBMzbKElXXstS2rdYsWKqiJhQy5epa1UpJ4GxR9/ARly6A==
X-Received: by 2002:a1c:e902:0:b0:3a0:2d95:49d4 with SMTP id q2-20020a1ce902000000b003a02d9549d4mr3574000wmc.189.1658317978548;
        Wed, 20 Jul 2022 04:52:58 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id x16-20020adfec10000000b0021e4edba1e5sm622156wrn.111.2022.07.20.04.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 04:52:58 -0700 (PDT)
Date:   Wed, 20 Jul 2022 12:52:56 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RESEND 1/1] Bluetooth: Use chan_list_lock to protect the whole
 put/destroy invokation
Message-ID: <YtfsmHt4R/WxJOTV@google.com>
References: <20220622082716.478486-1-lee.jones@linaro.org>
 <CANn89iK-uFP6Swgc0ZeEC38UsuywJ3wbybSNouH202Wa7X7Tzg@mail.gmail.com>
 <CABBYNZ+C=MQ7577Fr5_W8tQ4iWRSDBSiC4fkRBY3x=9ph+YAzA@mail.gmail.com>
 <CABBYNZLysdh3NFK+G8=NUQ=G=hvS8X0PdMp=bVqiwPDPCAokmg@mail.gmail.com>
 <YrxvgIiWuFVlXBaQ@google.com>
 <CABBYNZJFSxk9=3Gj7jOj__s=iJGmhrZ=CA7Mb74_-Y0sg+N40g@mail.gmail.com>
 <YsVptCjpzHjR8Scv@google.com>
 <CABBYNZKvVKRRdWnX3uFWdTXJ_S+oAj6z72zgyV148VmFtUnPpA@mail.gmail.com>
 <CABBYNZLTzW3afEPVfg=uS=xsPP-JpW6UBp6W=Urhhab+ai+dcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABBYNZLTzW3afEPVfg=uS=xsPP-JpW6UBp6W=Urhhab+ai+dcA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 06 Jul 2022, Luiz Augusto von Dentz wrote:
> > > > > > Perhaps something like this:
> > > > >
> > > > > I'm struggling to apply this for test:
> > > > >
> > > > >   "error: corrupt patch at line 6"
> > > >
> > > > Check with the attached patch.
> > >
> > > With the patch applied:
> > >
> > > [  188.825418][   T75] refcount_t: addition on 0; use-after-free.
> > > [  188.825418][   T75] refcount_t: addition on 0; use-after-free.
> >
> > Looks like the changes just make the issue more visible since we are
> > trying to add a refcount when it is already 0 so this proves the
> > design is not quite right since it is removing the object from the
> > list only when destroying it while we probably need to do it before.
> >
> > How about we use kref_get_unless_zero as it appears it was introduced
> > exactly for such cases (patch attached.)
> 
> Looks like I missed a few places like l2cap_global_chan_by_psm so here
> is another version.

Okay, with the patch below the kernel doesn't produce a back-trace.

Only this, which I assume is expected?

[  535.398255][  T495] Bluetooth: hci0: unexpected cc 0x0c03 length: 249 > 1                                                          
[  535.398255][  T495] Bluetooth: hci0: unexpected cc 0x0c03 length: 249 > 1                                                          
[  535.417007][  T495] Bluetooth: hci0: unexpected cc 0x1003 length: 249 > 9                                                          
[  535.417007][  T495] Bluetooth: hci0: unexpected cc 0x1003 length: 249 > 9                                                          
[  535.434810][  T495] Bluetooth: hci0: unexpected cc 0x1001 length: 249 > 9                                                          
[  535.434810][  T495] Bluetooth: hci0: unexpected cc 0x1001 length: 249 > 9                                                          
[  535.452886][  T495] Bluetooth: hci0: unexpected cc 0x0c23 length: 249 > 4                                                          
[  535.452886][  T495] Bluetooth: hci0: unexpected cc 0x0c23 length: 249 > 4                                                          
[  535.470574][  T495] Bluetooth: hci0: unexpected cc 0x0c25 length: 249 > 3                                                          
[  535.470574][  T495] Bluetooth: hci0: unexpected cc 0x0c25 length: 249 > 3                                                          
[  535.488009][  T495] Bluetooth: hci0: unexpected cc 0x0c38 length: 249 > 2                                                          
[  535.488009][  T495] Bluetooth: hci0: unexpected cc 0x0c38 length: 249 > 2                                                          
[  537.551677][   T74] Bluetooth: hci0: command 0x0409 tx timeout                                                                     
[  537.551677][   T74] Bluetooth: hci0: command 0x0409 tx timeout                                                                     
[  539.641362][  T373] Bluetooth: hci0: command 0x041b tx timeout                                                                     
[  539.641362][  T373] Bluetooth: hci0: command 0x041b tx timeout                                                                     
[  541.711056][  T274] Bluetooth: hci0: command 0x040f tx timeout                                                                     
[  541.711056][  T274] Bluetooth: hci0: command 0x040f tx timeout                                                                     
[  543.790939][   T66] Bluetooth: hci0: command 0x0419 tx timeout                                                                     
[  543.790939][   T66] Bluetooth: hci0: command 0x0419 tx timeout

> From 235937ac7a39d16e5dabbfca0ac1d58e4cc814d9 Mon Sep 17 00:00:00 2001
> From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Date: Tue, 28 Jun 2022 15:46:04 -0700
> Subject: [PATCH] Bluetooth: L2CAP: WIP
> 
> Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> ---
>  include/net/bluetooth/l2cap.h |  1 +
>  net/bluetooth/l2cap_core.c    | 58 +++++++++++++++++++++++++++--------
>  2 files changed, 46 insertions(+), 13 deletions(-)
> 
> diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
> index 3c4f550e5a8b..2f766e3437ce 100644
> --- a/include/net/bluetooth/l2cap.h
> +++ b/include/net/bluetooth/l2cap.h
> @@ -847,6 +847,7 @@ enum {
>  };
>  
>  void l2cap_chan_hold(struct l2cap_chan *c);
> +struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c);
>  void l2cap_chan_put(struct l2cap_chan *c);
>  
>  static inline void l2cap_chan_lock(struct l2cap_chan *chan)
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 09ecaf556de5..3e5d81e971cc 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -111,7 +111,8 @@ static struct l2cap_chan *__l2cap_get_chan_by_scid(struct l2cap_conn *conn,
>  }
>  
>  /* Find channel with given SCID.
> - * Returns locked channel. */
> + * Returns a reference locked channel.
> + */
>  static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn *conn,
>  						 u16 cid)
>  {
> @@ -119,15 +120,19 @@ static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn *conn,
>  
>  	mutex_lock(&conn->chan_lock);
>  	c = __l2cap_get_chan_by_scid(conn, cid);
> -	if (c)
> -		l2cap_chan_lock(c);
> +	if (c) {
> +		/* Only lock if chan reference is not 0 */
> +		c = l2cap_chan_hold_unless_zero(c);
> +		if (c)
> +			l2cap_chan_lock(c);
> +	}
>  	mutex_unlock(&conn->chan_lock);
>  
>  	return c;
>  }
>  
>  /* Find channel with given DCID.
> - * Returns locked channel.
> + * Returns a reference locked channel.
>   */
>  static struct l2cap_chan *l2cap_get_chan_by_dcid(struct l2cap_conn *conn,
>  						 u16 cid)
> @@ -136,8 +141,12 @@ static struct l2cap_chan *l2cap_get_chan_by_dcid(struct l2cap_conn *conn,
>  
>  	mutex_lock(&conn->chan_lock);
>  	c = __l2cap_get_chan_by_dcid(conn, cid);
> -	if (c)
> -		l2cap_chan_lock(c);
> +	if (c) {
> +		/* Only lock if chan reference is not 0 */
> +		c = l2cap_chan_hold_unless_zero(c);
> +		if (c)
> +			l2cap_chan_lock(c);
> +	}
>  	mutex_unlock(&conn->chan_lock);
>  
>  	return c;
> @@ -162,8 +171,12 @@ static struct l2cap_chan *l2cap_get_chan_by_ident(struct l2cap_conn *conn,
>  
>  	mutex_lock(&conn->chan_lock);
>  	c = __l2cap_get_chan_by_ident(conn, ident);
> -	if (c)
> -		l2cap_chan_lock(c);
> +	if (c) {
> +		/* Only lock if chan reference is not 0 */
> +		c = l2cap_chan_hold_unless_zero(c);
> +		if (c)
> +			l2cap_chan_lock(c);
> +	}
>  	mutex_unlock(&conn->chan_lock);
>  
>  	return c;
> @@ -497,6 +510,16 @@ void l2cap_chan_hold(struct l2cap_chan *c)
>  	kref_get(&c->kref);
>  }
>  
> +struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c)
> +{
> +	BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
> +
> +	if (!kref_get_unless_zero(&c->kref))
> +		return NULL;
> +
> +	return c;
> +}
> +
>  void l2cap_chan_put(struct l2cap_chan *c)
>  {
>  	BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
> @@ -1969,7 +1992,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
>  			src_match = !bacmp(&c->src, src);
>  			dst_match = !bacmp(&c->dst, dst);
>  			if (src_match && dst_match) {
> -				l2cap_chan_hold(c);
> +				c = l2cap_chan_hold_unless_zero(c);
>  				read_unlock(&chan_list_lock);
>  				return c;
>  			}
> @@ -1984,7 +2007,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
>  	}
>  
>  	if (c1)
> -		l2cap_chan_hold(c1);
> +		c1 = l2cap_chan_hold_unless_zero(c1);
>  
>  	read_unlock(&chan_list_lock);
>  
> @@ -4464,6 +4487,7 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
>  
>  unlock:
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  	return err;
>  }
>  
> @@ -4578,6 +4602,7 @@ static inline int l2cap_config_rsp(struct l2cap_conn *conn,
>  
>  done:
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  	return err;
>  }
>  
> @@ -5305,6 +5330,7 @@ static inline int l2cap_move_channel_req(struct l2cap_conn *conn,
>  	l2cap_send_move_chan_rsp(chan, result);
>  
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  
>  	return 0;
>  }
> @@ -5397,6 +5423,7 @@ static void l2cap_move_continue(struct l2cap_conn *conn, u16 icid, u16 result)
>  	}
>  
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  }
>  
>  static void l2cap_move_fail(struct l2cap_conn *conn, u8 ident, u16 icid,
> @@ -5426,6 +5453,7 @@ static void l2cap_move_fail(struct l2cap_conn *conn, u8 ident, u16 icid,
>  	l2cap_send_move_chan_cfm(chan, L2CAP_MC_UNCONFIRMED);
>  
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  }
>  
>  static int l2cap_move_channel_rsp(struct l2cap_conn *conn,
> @@ -5489,6 +5517,7 @@ static int l2cap_move_channel_confirm(struct l2cap_conn *conn,
>  	l2cap_send_move_chan_cfm_rsp(conn, cmd->ident, icid);
>  
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  
>  	return 0;
>  }
> @@ -5524,6 +5553,7 @@ static inline int l2cap_move_channel_confirm_rsp(struct l2cap_conn *conn,
>  	}
>  
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  
>  	return 0;
>  }
> @@ -5896,12 +5926,11 @@ static inline int l2cap_le_credits(struct l2cap_conn *conn,
>  	if (credits > max_credits) {
>  		BT_ERR("LE credits overflow");
>  		l2cap_send_disconn_req(chan, ECONNRESET);
> -		l2cap_chan_unlock(chan);
>  
>  		/* Return 0 so that we don't trigger an unnecessary
>  		 * command reject packet.
>  		 */
> -		return 0;
> +		goto unlock;
>  	}
>  
>  	chan->tx_credits += credits;
> @@ -5912,7 +5941,9 @@ static inline int l2cap_le_credits(struct l2cap_conn *conn,
>  	if (chan->tx_credits)
>  		chan->ops->resume(chan);
>  
> +unlock:
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  
>  	return 0;
>  }
> @@ -7598,6 +7629,7 @@ static void l2cap_data_channel(struct l2cap_conn *conn, u16 cid,
>  
>  done:
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  }
>  
>  static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
> @@ -8086,7 +8118,7 @@ static struct l2cap_chan *l2cap_global_fixed_chan(struct l2cap_chan *c,
>  		if (src_type != c->src_type)
>  			continue;
>  
> -		l2cap_chan_hold(c);
> +		c = l2cap_chan_hold_unless_zero(c);
>  		read_unlock(&chan_list_lock);
>  		return c;
>  	}


-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

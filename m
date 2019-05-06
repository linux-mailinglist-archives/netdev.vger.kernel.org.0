Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D5014550
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 09:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbfEFHeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 03:34:14 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44269 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfEFHeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 03:34:14 -0400
Received: by mail-pl1-f196.google.com with SMTP id d3so1913897plj.11
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 00:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rdNiX2c6JEoDn51y8od+eIjOuGdnYI1o69CP3BYjREM=;
        b=MFLmYkMnxh67KuYR5uCOyAzaoyPnFA7gAH4uApNJ0PxIo7blGKTsoHutONc6ls/aus
         4j4/dsZEyEM3CF4Is6MBpO3d0yhyLjIN5Baw2E6rD5yNl/Do8Qfjd1CBSHRipm9m8r1p
         tjrs1JAVTTBCQQ7KNkjKCE2+dA/V6JBoddJvHXtpLDNdV8p1J+cv6jwPV45qXchto6LK
         ccQOTDlHfhgVB5VvPm5uy4uC6t+yi6hmdckNB0QlcIAcDc/WBL8rb9ULKFcj++5PoQb2
         v5ydQoZ9ejrU5N/YHdRt8fq5hMcNLFEAyPBvx6eYRts9zN/TV720W00U9xlLeWo1TuES
         4nUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rdNiX2c6JEoDn51y8od+eIjOuGdnYI1o69CP3BYjREM=;
        b=SICO/amdh7w7V4GUztRwIOuAYQ2Vf7D8Wh+94mETi8u4zZ0nbAqlhNvz4vsvEyBAKq
         l/NmoWfYnQQZMsz9XQZA6kX4aPajh+r05WEE9EuFfNWAJzuZ4EfRHtJqy8bXwhCbdjTv
         s5kALn/JNwliYbDkZQr8PPArJdKBcLmBJkQ1tp7V6hNBgyC1z4KLaqOPXwbCY0ssXEJ5
         HHOcfOfnk/BfWsp2GGOtuXwIwEdsARN0W1O/0q1WM8tDNMWmrclH6C+7OuXf5RAIBrWp
         PbWt8e1/TT8uMZ1FqYCO2R4qzPc6cqvwT1f/vYqwkWbyoE61iU/WwsCys8UX3QvZChn6
         8q7Q==
X-Gm-Message-State: APjAAAXPHL2rAhRRkh6ZrA4fNCwEF/HzNmOKTgp92diTB3lUwIuCbSrl
        AwPhRRd7C8E1UbS0M2KwGXI=
X-Google-Smtp-Source: APXvYqwOU2suha5u3GLyYkvyUu/zPeATI1PnkQX6j5ECzBXT4Dm4m2p9SWR39tXvq5XcjKN11TqMaQ==
X-Received: by 2002:a17:902:9a83:: with SMTP id w3mr30863487plp.241.1557128053179;
        Mon, 06 May 2019 00:34:13 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g3sm6516920pgh.69.2019.05.06.00.34.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 00:34:12 -0700 (PDT)
Date:   Mon, 6 May 2019 15:34:02 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Jiri Benc <jbenc@redhat.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>,
        stefan.sorensen@spectralink.com
Subject: Re: [PATCH net-next] macvlan: pass get_ts_info and SIOC[SG]HWTSTAMP
 ioctl to real device
Message-ID: <20190506073401.GK18865@dhcp-12-139.nay.redhat.com>
References: <20190417061452.GA18865@dhcp-12-139.nay.redhat.com>
 <20190417154306.om6rjkxq4hikhsht@localhost>
 <20190417205958.6508bda2@redhat.com>
 <20190418033157.irs25halxnemh65y@localhost>
 <20190418080509.GD5984@localhost>
 <20190423041817.GE18865@dhcp-12-139.nay.redhat.com>
 <20190423083141.GA5188@localhost>
 <20190423091543.GF18865@dhcp-12-139.nay.redhat.com>
 <20190423093213.GA7246@localhost>
 <20190425134006.GG18865@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425134006.GG18865@dhcp-12-139.nay.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 25, 2019 at 09:40:06PM +0800, Hangbin Liu wrote:
> On Tue, Apr 23, 2019 at 11:32:13AM +0200, Miroslav Lichvar wrote:
> > If those values I described above were in an array called ts_map
> > indexed by the RX filter enum, I think the check could just be:
> > 
> > 	(ts_map[old_filter] & ts_map[new_filter]) == tsmap[old_filter]
> > 
> > The individual bits would correspond to:
> > 
> > PTP_V1_L4_SYNC
> > PTP_V1_L4_DELAY_REQ
> > PTP_V2_L4_SYNC
> > PTP_V2_L4_DELAY_REQ
> > PTP_V2_L2_SYNC
> > PTP_V2_L2_DELAY_REQ
> > NTP_ALL
> > 
> > And the remaining RX filters would be combinations of those.
> > 
> > -- 
> Hi Miroslav, Richard,
> 
> Here is a draft patch with your idea. I haven't test it and it may has some
> issues. But the logic should looks like what you said. The copy_from/to_user
> is a little ugly, but I haven't come up with a more gentle way.
> 
> Would you please help have a look at it and see which way we should use?
> Drop SIOCSHWTSTAMP in container or add a filter on macvlan(maybe only in
> container)?

Hi Richard,

Any suggestion?

Thanks
Hangbin

> 
> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> index 4a6be8fab884..0f87a42fc61c 100644
> --- a/drivers/net/macvlan.c
> +++ b/drivers/net/macvlan.c
> @@ -824,18 +824,75 @@ static int macvlan_change_mtu(struct net_device *dev, int new_mtu)
>  	return 0;
>  }
>  
> +int check_rx_filter(unsigned int new_filter, unsigned int old_filter)
> +{
> +	u8 ts_map[HWTSTAMP_FILTER_NTP_ALL];
> +
> +	memset(ts_map, 0, sizeof(ts_map));
> +
> +	ts_map[HWTSTAMP_FILTER_PTP_V1_L4_SYNC - 1] = 0x01;
> +	ts_map[HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ - 1] = 0x02;
> +	ts_map[HWTSTAMP_FILTER_PTP_V1_L4_EVENT - 1] = 0x03;
> +
> +	ts_map[HWTSTAMP_FILTER_PTP_V2_L4_SYNC - 1] = 0x11;
> +	ts_map[HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ - 1] = 0x12;
> +	ts_map[HWTSTAMP_FILTER_PTP_V2_L4_EVENT - 1] = 0x13;
> +
> +	ts_map[HWTSTAMP_FILTER_PTP_V2_SYNC - 1] = 0x31;
> +	ts_map[HWTSTAMP_FILTER_PTP_V2_DELAY_REQ - 1] = 0x32;
> +	ts_map[HWTSTAMP_FILTER_PTP_V2_EVENT - 1] = 0x33;
> +
> +	ts_map[HWTSTAMP_FILTER_NTP_ALL - 1] = 0xF0;
> +	ts_map[HWTSTAMP_FILTER_ALL - 1] = 0xFF;
> +
> +	if ((ts_map[new_filter] & ts_map[old_filter]) == ts_map[old_filter])
> +		return 0;
> +	else
> +		return -EACCES;
> +}
> +
>  static int macvlan_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  {
>  	struct net_device *real_dev = macvlan_dev_real_dev(dev);
>  	const struct net_device_ops *ops = real_dev->netdev_ops;
> -	struct ifreq ifrr;
> +	unsigned int old_filter, new_filter, new_tx_type;
> +	struct hwtstamp_config new_stmpconf, old_stmpconf;
>  	int err = -EOPNOTSUPP;
> +	struct ifreq ifrr;
> +
> +	/* Get new rx_filter */
> +	if (copy_from_user(&new_stmpconf, ifr->ifr_data, sizeof(new_stmpconf))) {
> +		return -EFAULT;
> +	} else {
> +		new_tx_type = new_stmpconf.tx_type;
> +		new_filter = new_stmpconf.rx_filter;
> +	}
>  
> +	/* Get old rx_filter */
>  	strncpy(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
>  	ifrr.ifr_ifru = ifr->ifr_ifru;
>  
> +	if (netif_device_present(real_dev) && ops->ndo_do_ioctl)
> +		err = ops->ndo_do_ioctl(real_dev, &ifrr, SIOCGHWTSTAMP);
> +
> +	if (!err && copy_from_user(&old_stmpconf, ifrr.ifr_data, sizeof(old_stmpconf)))
> +		old_filter = old_stmpconf.rx_filter;
> +	else
> +		return err;
> +
> +	/* Copy new data back */
> +	if (copy_to_user(ifrr.ifr_data, &new_stmpconf, sizeof(new_stmpconf)))
> +		return -EFAULT;
> +
>  	switch (cmd) {
>  	case SIOCSHWTSTAMP:
> +		if (new_tx_type != HWTSTAMP_TX_ON ||
> +		    new_filter == HWTSTAMP_FILTER_SOME)
> +			return err;
> +
> +		err = check_rx_filter(new_filter, old_filter);
> +		if (err)
> +			break;
>  	case SIOCGHWTSTAMP:
>  		if (netif_device_present(real_dev) && ops->ndo_do_ioctl)
>  			err = ops->ndo_do_ioctl(real_dev, &ifrr, cmd);
> -- 
> 2.19.2
> 

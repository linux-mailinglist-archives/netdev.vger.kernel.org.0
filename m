Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF56E3FEB51
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 11:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343611AbhIBJbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 05:31:08 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:39959 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343524AbhIBJbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 05:31:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id A28232B00930;
        Thu,  2 Sep 2021 05:30:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 02 Sep 2021 05:30:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=85vIZ1l34x7ueryiu4FrbO6lGoT
        8wxWMU7+/qeH4218=; b=RpQd7Yu/09NM/siSk0hNl1YJJp7MPkYRkd6/M8/AJVr
        dEsuwqJGS1WyDgDAXoV/b/Xniqwe/yOBf/Y6vlwu/T5gV+zb1qOKvRuKpofURMPn
        vhSWRJXUOQBlm6cAH1iaB3UpYg2nGzc0EqcQ8F/Fwd1QoE1JNSpol5SYOIshD2Ve
        f2+lhejuj3nMsGafSI8Y3mn+bZaoRw4VrUg2thf8nbSuSktTBIW2rUnFtw+0aE6X
        PRRr6Qe6CnNYp8rk6yo5z4sa2lkadeBXNIqDwB8EJDSw/jmYLGeG3bLcU6zJt3rM
        95IZZjcIoG4y+rzAElWs8vn3nSq0nDA7waOWRIwQb8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=85vIZ1
        l34x7ueryiu4FrbO6lGoT8wxWMU7+/qeH4218=; b=GjMitDeCQKhXowwK0OhuDR
        QI8qGPGYgk+tu5a5xmER7Eijs5CcaB5UNMQE+xuSk6Y+hr6TfNNQccrYP5jb9uBc
        TFvqQOtEKWk4htBxGgR68a1ghWqpnxQKhBNCFxmlvaBhOPmldxkUYZtylPKGX2D2
        AH6pm3B2OHACyoWOLWNmdIBsQafN7h0fFSrM6QlJzH2GbGVC1rAOgGBjnMxAYLXT
        yyApL6/P8ez7ACsZvkRD3kgdG1UUMLpG0iSGvWIveFqAXlDhb3EyYQ75EZLzyaM5
        /u0sIZJ2VuQ7xv+vuhLg8vsUlv6fWcy3WUwKsX9ljK5EZGwOjz++SSdcKUPrm0XA
        ==
X-ME-Sender: <xms:npkwYcu7QYyN-3a8dcOtR5c-L41VXXCsR1kJhzvzlHHSXXk0ypuEIQ>
    <xme:npkwYZdzzzcyJBzkqZ3PS1HPpDSBwKSyPcox1UM0dLalxyyF-UcFRGeJ61ZViqXs1
    TG8dNQyrqVDJQ>
X-ME-Received: <xmr:npkwYXw5wp2pQLDzv9dHix_e6NsdUrKmgCDk4w558_1WH8tGwl3SRqhTaMg5iCLEaOZ8RUJ1PKJWx8DxGBXvPn55vsl73MZl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvhedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:npkwYfNNi3avM8FsuSWKZLlMwfwrSa4aUD5hoPGVzw1fF9B3tjMKBA>
    <xmx:npkwYc9GoHPF_lTgonfjkbm_XdoJXCSrLOuyyk0IHEZIMNabZ4FXdA>
    <xmx:npkwYXW8loTwHlDDW-qAFqdZuImcmULMD-6ubYF5Ej19izbJa_wwAA>
    <xmx:oJkwYXXxJsh31AYHuucBenUAVw2gUZgkgFNUzyg-f5vzvkabCTo2a736HlQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Sep 2021 05:30:05 -0400 (EDT)
Date:   Thu, 2 Sep 2021 11:29:52 +0200
From:   Greg KH <greg@kroah.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the staging
 tree
Message-ID: <YTCZkN0nROdhId3m@kroah.com>
References: <20210830114238.7c322caa@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830114238.7c322caa@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 11:42:38AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in:
> 
>   drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
> 
> between commit:
> 
>   174ac41a7aaf ("staging: rtl8723bs: remove obsolete wext support")
> 
> from the staging tree and commit:
> 
>   89939e890605 ("staging: rtlwifi: use siocdevprivate")
> 
> from the net-next tree.
> 
> I fixed it up (see below - though it is probably better to get rid of
> rtw_siocdevprivate() as well) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 
> -- 
> Cheers,
> Stephen Rothwell
> 
> diff --cc drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
> index 9d4a233a861e,aa7bd76bb5f1..000000000000
> --- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
> +++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
> @@@ -1335,8 -3728,778 +1335,21 @@@ static int rtw_hostapd_ioctl(struct net
>   	return ret;
>   }
>   
>  -static int rtw_wx_set_priv(struct net_device *dev,
>  -				struct iw_request_info *info,
>  -				union iwreq_data *awrq,
>  -				char *extra)
>  -{
>  -
>  -#ifdef DEBUG_RTW_WX_SET_PRIV
>  -	char *ext_dbg;
>  -#endif
>  -
>  -	int ret = 0;
>  -	int len = 0;
>  -	char *ext;
>  -
>  -	struct adapter *padapter = rtw_netdev_priv(dev);
>  -	struct iw_point *dwrq = (struct iw_point *)awrq;
>  -
>  -	if (dwrq->length == 0)
>  -		return -EFAULT;
>  -
>  -	len = dwrq->length;
>  -	ext = vmalloc(len);
>  -	if (!ext)
>  -		return -ENOMEM;
>  -
>  -	if (copy_from_user(ext, dwrq->pointer, len)) {
>  -		vfree(ext);
>  -		return -EFAULT;
>  -	}
>  -
>  -	#ifdef DEBUG_RTW_WX_SET_PRIV
>  -	ext_dbg = vmalloc(len);
>  -	if (!ext_dbg) {
>  -		vfree(ext, len);
>  -		return -ENOMEM;
>  -	}
>  -
>  -	memcpy(ext_dbg, ext, len);
>  -	#endif
>  -
>  -	/* added for wps2.0 @20110524 */
>  -	if (dwrq->flags == 0x8766 && len > 8) {
>  -		u32 cp_sz;
>  -		struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
>  -		u8 *probereq_wpsie = ext;
>  -		int probereq_wpsie_len = len;
>  -		u8 wps_oui[4] = {0x0, 0x50, 0xf2, 0x04};
>  -
>  -		if ((WLAN_EID_VENDOR_SPECIFIC == probereq_wpsie[0]) &&
>  -			(!memcmp(&probereq_wpsie[2], wps_oui, 4))) {
>  -			cp_sz = probereq_wpsie_len > MAX_WPS_IE_LEN ? MAX_WPS_IE_LEN : probereq_wpsie_len;
>  -
>  -			if (pmlmepriv->wps_probe_req_ie) {
>  -				pmlmepriv->wps_probe_req_ie_len = 0;
>  -				kfree(pmlmepriv->wps_probe_req_ie);
>  -				pmlmepriv->wps_probe_req_ie = NULL;
>  -			}
>  -
>  -			pmlmepriv->wps_probe_req_ie = rtw_malloc(cp_sz);
>  -			if (pmlmepriv->wps_probe_req_ie == NULL) {
>  -				printk("%s()-%d: rtw_malloc() ERROR!\n", __func__, __LINE__);
>  -				ret =  -EINVAL;
>  -				goto FREE_EXT;
>  -
>  -			}
>  -
>  -			memcpy(pmlmepriv->wps_probe_req_ie, probereq_wpsie, cp_sz);
>  -			pmlmepriv->wps_probe_req_ie_len = cp_sz;
>  -
>  -		}
>  -
>  -		goto FREE_EXT;
>  -
>  -	}
>  -
>  -	if (len >= WEXT_CSCAN_HEADER_SIZE
>  -		&& !memcmp(ext, WEXT_CSCAN_HEADER, WEXT_CSCAN_HEADER_SIZE)) {
>  -		ret = rtw_wx_set_scan(dev, info, awrq, ext);
>  -		goto FREE_EXT;
>  -	}
>  -
>  -FREE_EXT:
>  -
>  -	vfree(ext);
>  -	#ifdef DEBUG_RTW_WX_SET_PRIV
>  -	vfree(ext_dbg);
>  -	#endif
>  -
>  -	return ret;
>  -
>  -}
>  -
>  -static int rtw_pm_set(struct net_device *dev,
>  -		      struct iw_request_info *info,
>  -		      union iwreq_data *wrqu, char *extra)
>  -{
>  -	int ret = 0;
>  -	unsigned	mode = 0;
>  -	struct adapter *padapter = rtw_netdev_priv(dev);
>  -
>  -	if (!memcmp(extra, "lps =", 4)) {
>  -		sscanf(extra+4, "%u", &mode);
>  -		ret = rtw_pm_set_lps(padapter, mode);
>  -	} else if (!memcmp(extra, "ips =", 4)) {
>  -		sscanf(extra+4, "%u", &mode);
>  -		ret = rtw_pm_set_ips(padapter, mode);
>  -	} else {
>  -		ret = -EINVAL;
>  -	}
>  -
>  -	return ret;
>  -}
>  -
>  -static int rtw_test(
>  -	struct net_device *dev,
>  -	struct iw_request_info *info,
>  -	union iwreq_data *wrqu, char *extra)
>  -{
>  -	u32 len;
>  -	u8 *pbuf, *pch;
>  -	char *ptmp;
>  -	u8 *delim = ",";
>  -	struct adapter *padapter = rtw_netdev_priv(dev);
>  -
>  -
>  -	len = wrqu->data.length;
>  -
>  -	pbuf = rtw_zmalloc(len);
>  -	if (!pbuf)
>  -		return -ENOMEM;
>  -
>  -	if (copy_from_user(pbuf, wrqu->data.pointer, len)) {
>  -		kfree(pbuf);
>  -		return -EFAULT;
>  -	}
>  -
>  -	ptmp = (char *)pbuf;
>  -	pch = strsep(&ptmp, delim);
>  -	if ((pch == NULL) || (strlen(pch) == 0)) {
>  -		kfree(pbuf);
>  -		return -EFAULT;
>  -	}
>  -
>  -	if (strcmp(pch, "bton") == 0)
>  -		hal_btcoex_SetManualControl(padapter, false);
>  -
>  -	if (strcmp(pch, "btoff") == 0)
>  -		hal_btcoex_SetManualControl(padapter, true);
>  -
>  -	if (strcmp(pch, "h2c") == 0) {
>  -		u8 param[8];
>  -		u8 count = 0;
>  -		u32 tmp;
>  -		u8 i;
>  -		u32 pos;
>  -		s32 ret;
>  -
>  -
>  -		do {
>  -			pch = strsep(&ptmp, delim);
>  -			if ((pch == NULL) || (strlen(pch) == 0))
>  -				break;
>  -
>  -			sscanf(pch, "%x", &tmp);
>  -			param[count++] = (u8)tmp;
>  -		} while (count < 8);
>  -
>  -		if (count == 0) {
>  -			kfree(pbuf);
>  -			return -EFAULT;
>  -		}
>  -
>  -		ret = rtw_hal_fill_h2c_cmd(padapter, param[0], count-1, &param[1]);
>  -
>  -		pos = sprintf(extra, "H2C ID = 0x%02x content =", param[0]);
>  -		for (i = 1; i < count; i++)
>  -			pos += sprintf(extra+pos, "%02x,", param[i]);
>  -		extra[pos] = 0;
>  -		pos--;
>  -		pos += sprintf(extra+pos, " %s", ret == _FAIL?"FAIL":"OK");
>  -
>  -		wrqu->data.length = strlen(extra) + 1;
>  -	}
>  -
>  -	kfree(pbuf);
>  -	return 0;
>  -}
>  -
>  -static iw_handler rtw_handlers[] = {
>  -	NULL,					/* SIOCSIWCOMMIT */
>  -	rtw_wx_get_name,		/* SIOCGIWNAME */
>  -	dummy,					/* SIOCSIWNWID */
>  -	dummy,					/* SIOCGIWNWID */
>  -	rtw_wx_set_freq,		/* SIOCSIWFREQ */
>  -	rtw_wx_get_freq,		/* SIOCGIWFREQ */
>  -	rtw_wx_set_mode,		/* SIOCSIWMODE */
>  -	rtw_wx_get_mode,		/* SIOCGIWMODE */
>  -	dummy,					/* SIOCSIWSENS */
>  -	rtw_wx_get_sens,		/* SIOCGIWSENS */
>  -	NULL,					/* SIOCSIWRANGE */
>  -	rtw_wx_get_range,		/* SIOCGIWRANGE */
>  -	rtw_wx_set_priv,		/* SIOCSIWPRIV */
>  -	NULL,					/* SIOCGIWPRIV */
>  -	NULL,					/* SIOCSIWSTATS */
>  -	NULL,					/* SIOCGIWSTATS */
>  -	dummy,					/* SIOCSIWSPY */
>  -	dummy,					/* SIOCGIWSPY */
>  -	NULL,					/* SIOCGIWTHRSPY */
>  -	NULL,					/* SIOCWIWTHRSPY */
>  -	rtw_wx_set_wap,		/* SIOCSIWAP */
>  -	rtw_wx_get_wap,		/* SIOCGIWAP */
>  -	rtw_wx_set_mlme,		/* request MLME operation; uses struct iw_mlme */
>  -	dummy,					/* SIOCGIWAPLIST -- depricated */
>  -	rtw_wx_set_scan,		/* SIOCSIWSCAN */
>  -	rtw_wx_get_scan,		/* SIOCGIWSCAN */
>  -	rtw_wx_set_essid,		/* SIOCSIWESSID */
>  -	rtw_wx_get_essid,		/* SIOCGIWESSID */
>  -	dummy,					/* SIOCSIWNICKN */
>  -	rtw_wx_get_nick,		/* SIOCGIWNICKN */
>  -	NULL,					/* -- hole -- */
>  -	NULL,					/* -- hole -- */
>  -	rtw_wx_set_rate,		/* SIOCSIWRATE */
>  -	rtw_wx_get_rate,		/* SIOCGIWRATE */
>  -	rtw_wx_set_rts,			/* SIOCSIWRTS */
>  -	rtw_wx_get_rts,			/* SIOCGIWRTS */
>  -	rtw_wx_set_frag,		/* SIOCSIWFRAG */
>  -	rtw_wx_get_frag,		/* SIOCGIWFRAG */
>  -	dummy,					/* SIOCSIWTXPOW */
>  -	dummy,					/* SIOCGIWTXPOW */
>  -	dummy,					/* SIOCSIWRETRY */
>  -	rtw_wx_get_retry,		/* SIOCGIWRETRY */
>  -	rtw_wx_set_enc,			/* SIOCSIWENCODE */
>  -	rtw_wx_get_enc,			/* SIOCGIWENCODE */
>  -	dummy,					/* SIOCSIWPOWER */
>  -	rtw_wx_get_power,		/* SIOCGIWPOWER */
>  -	NULL,					/*---hole---*/
>  -	NULL,					/*---hole---*/
>  -	rtw_wx_set_gen_ie,		/* SIOCSIWGENIE */
>  -	NULL,					/* SIOCGWGENIE */
>  -	rtw_wx_set_auth,		/* SIOCSIWAUTH */
>  -	NULL,					/* SIOCGIWAUTH */
>  -	rtw_wx_set_enc_ext,		/* SIOCSIWENCODEEXT */
>  -	NULL,					/* SIOCGIWENCODEEXT */
>  -	rtw_wx_set_pmkid,		/* SIOCSIWPMKSA */
>  -	NULL,					/*---hole---*/
>  -};
>  -
>  -static const struct iw_priv_args rtw_private_args[] = {
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x0,
>  -		IW_PRIV_TYPE_CHAR | 0x7FF, 0, "write"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x1,
>  -		IW_PRIV_TYPE_CHAR | 0x7FF,
>  -		IW_PRIV_TYPE_CHAR | IW_PRIV_SIZE_FIXED | IFNAMSIZ, "read"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x2, 0, 0, "driver_ext"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x3, 0, 0, "mp_ioctl"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x4,
>  -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "apinfo"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x5,
>  -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 2, 0, "setpid"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x6,
>  -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "wps_start"
>  -	},
>  -/* for PLATFORM_MT53XX */
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x7,
>  -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "get_sensitivity"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x8,
>  -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "wps_prob_req_ie"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x9,
>  -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "wps_assoc_req_ie"
>  -	},
>  -
>  -/* for RTK_DMP_PLATFORM */
>  -	{
>  -		SIOCIWFIRSTPRIV + 0xA,
>  -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "channel_plan"
>  -	},
>  -
>  -	{
>  -		SIOCIWFIRSTPRIV + 0xB,
>  -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 2, 0, "dbg"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0xC,
>  -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 3, 0, "rfw"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0xD,
>  -		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 2, IW_PRIV_TYPE_CHAR | IW_PRIV_SIZE_FIXED | IFNAMSIZ, "rfr"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x10,
>  -		IW_PRIV_TYPE_CHAR | 1024, 0, "p2p_set"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x11,
>  -		IW_PRIV_TYPE_CHAR | 1024, IW_PRIV_TYPE_CHAR | IW_PRIV_SIZE_MASK, "p2p_get"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x12, 0, 0, "NULL"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x13,
>  -		IW_PRIV_TYPE_CHAR | 64, IW_PRIV_TYPE_CHAR | 64, "p2p_get2"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x14,
>  -		IW_PRIV_TYPE_CHAR  | 64, 0, "tdls"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x15,
>  -		IW_PRIV_TYPE_CHAR | 1024, IW_PRIV_TYPE_CHAR | 1024, "tdls_get"
>  -	},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x16,
>  -		IW_PRIV_TYPE_CHAR | 64, 0, "pm_set"
>  -	},
>  -
>  -	{SIOCIWFIRSTPRIV + 0x18, IW_PRIV_TYPE_CHAR | IFNAMSIZ, 0, "rereg_nd_name"},
>  -	{SIOCIWFIRSTPRIV + 0x1A, IW_PRIV_TYPE_CHAR | 1024, 0, "efuse_set"},
>  -	{SIOCIWFIRSTPRIV + 0x1B, IW_PRIV_TYPE_CHAR | 128, IW_PRIV_TYPE_CHAR | IW_PRIV_SIZE_MASK, "efuse_get"},
>  -	{
>  -		SIOCIWFIRSTPRIV + 0x1D,
>  -		IW_PRIV_TYPE_CHAR | 40, IW_PRIV_TYPE_CHAR | 0x7FF, "test"
>  -	},
>  -};
>  -
>  -static iw_handler rtw_private_handler[] = {
>  -	rtw_wx_write32,					/* 0x00 */
>  -	rtw_wx_read32,					/* 0x01 */
>  -	rtw_drvext_hdl,					/* 0x02 */
>  -	NULL,						/* 0x03 */
>  -
>  -/*  for MM DTV platform */
>  -	rtw_get_ap_info,					/* 0x04 */
>  -
>  -	rtw_set_pid,						/* 0x05 */
>  -	rtw_wps_start,					/* 0x06 */
>  -
>  -/*  for PLATFORM_MT53XX */
>  -	rtw_wx_get_sensitivity,			/* 0x07 */
>  -	rtw_wx_set_mtk_wps_probe_ie,	/* 0x08 */
>  -	rtw_wx_set_mtk_wps_ie,			/* 0x09 */
>  -
>  -/*  for RTK_DMP_PLATFORM */
>  -/*  Set Channel depend on the country code */
>  -	rtw_wx_set_channel_plan,		/* 0x0A */
>  -
>  -	rtw_dbg_port,					/* 0x0B */
>  -	rtw_wx_write_rf,					/* 0x0C */
>  -	rtw_wx_read_rf,					/* 0x0D */
>  -	rtw_wx_priv_null,				/* 0x0E */
>  -	rtw_wx_priv_null,				/* 0x0F */
>  -	rtw_p2p_set,					/* 0x10 */
>  -	rtw_p2p_get,					/* 0x11 */
>  -	NULL,							/* 0x12 */
>  -	rtw_p2p_get2,					/* 0x13 */
>  -
>  -	NULL,						/* 0x14 */
>  -	NULL,						/* 0x15 */
>  -
>  -	rtw_pm_set,						/* 0x16 */
>  -	rtw_wx_priv_null,				/* 0x17 */
>  -	rtw_rereg_nd_name,				/* 0x18 */
>  -	rtw_wx_priv_null,				/* 0x19 */
>  -	NULL,						/* 0x1A */
>  -	NULL,						/* 0x1B */
>  -	NULL,							/*  0x1C is reserved for hostapd */
>  -	rtw_test,						/*  0x1D */
>  -};
>  -
>  -static struct iw_statistics *rtw_get_wireless_stats(struct net_device *dev)
>  -{
>  -	struct adapter *padapter = rtw_netdev_priv(dev);
>  -	struct iw_statistics *piwstats = &padapter->iwstats;
>  -	int tmp_level = 0;
>  -	int tmp_qual = 0;
>  -	int tmp_noise = 0;
>  -
>  -	if (check_fwstate(&padapter->mlmepriv, _FW_LINKED) != true) {
>  -		piwstats->qual.qual = 0;
>  -		piwstats->qual.level = 0;
>  -		piwstats->qual.noise = 0;
>  -	} else {
>  -		tmp_level = padapter->recvpriv.signal_strength;
>  -		tmp_qual = padapter->recvpriv.signal_qual;
>  -		tmp_noise = padapter->recvpriv.noise;
>  -
>  -		piwstats->qual.level = tmp_level;
>  -		piwstats->qual.qual = tmp_qual;
>  -		piwstats->qual.noise = tmp_noise;
>  -	}
>  -	piwstats->qual.updated = IW_QUAL_ALL_UPDATED ;/* IW_QUAL_DBM; */
>  -
>  -	return &padapter->iwstats;
>  -}
>  -
>  -struct iw_handler_def rtw_handlers_def = {
>  -	.standard = rtw_handlers,
>  -	.num_standard = ARRAY_SIZE(rtw_handlers),
>  -#if defined(CONFIG_WEXT_PRIV)
>  -	.private = rtw_private_handler,
>  -	.private_args = (struct iw_priv_args *)rtw_private_args,
>  -	.num_private = ARRAY_SIZE(rtw_private_handler),
>  -	.num_private_args = ARRAY_SIZE(rtw_private_args),
>  -#endif
>  -	.get_wireless_stats = rtw_get_wireless_stats,
>  -};
>  -
>  -/*  copy from net/wireless/wext.c start */
>  -/* ---------------------------------------------------------------- */
>  -/*
>  - * Calculate size of private arguments
>  - */
>  -static const char iw_priv_type_size[] = {
>  -	0,                              /* IW_PRIV_TYPE_NONE */
>  -	1,                              /* IW_PRIV_TYPE_BYTE */
>  -	1,                              /* IW_PRIV_TYPE_CHAR */
>  -	0,                              /* Not defined */
>  -	sizeof(__u32),                  /* IW_PRIV_TYPE_INT */
>  -	sizeof(struct iw_freq),         /* IW_PRIV_TYPE_FLOAT */
>  -	sizeof(struct sockaddr),        /* IW_PRIV_TYPE_ADDR */
>  -	0,                              /* Not defined */
>  -};
>  -
>  -static int get_priv_size(__u16 args)
>  -{
>  -	int num = args & IW_PRIV_SIZE_MASK;
>  -	int type = (args & IW_PRIV_TYPE_MASK) >> 12;
>  -
>  -	return num * iw_priv_type_size[type];
>  -}
>   /*  copy from net/wireless/wext.c end */
>   
>  -static int rtw_ioctl_wext_private(struct net_device *dev, union iwreq_data *wrq_data)
>  -{
>  -	int err = 0;
>  -	u8 *input = NULL;
>  -	u32 input_len = 0;
>  -	const char delim[] = " ";
>  -	u8 *output = NULL;
>  -	u32 output_len = 0;
>  -	u32 count = 0;
>  -	u8 *buffer = NULL;
>  -	u32 buffer_len = 0;
>  -	char *ptr = NULL;
>  -	u8 cmdname[17] = {0}; /*  IFNAMSIZ+1 */
>  -	u32 cmdlen;
>  -	s32 len;
>  -	u8 *extra = NULL;
>  -	u32 extra_size = 0;
>  -
>  -	s32 k;
>  -	const iw_handler *priv;		/* Private ioctl */
>  -	const struct iw_priv_args *priv_args;	/* Private ioctl description */
>  -	u32 num_priv_args;			/* Number of descriptions */
>  -	iw_handler handler;
>  -	int temp;
>  -	int subcmd = 0;				/* sub-ioctl index */
>  -	int offset = 0;				/* Space for sub-ioctl index */
>  -
>  -	union iwreq_data wdata;
>  -
>  -
>  -	memcpy(&wdata, wrq_data, sizeof(wdata));
>  -
>  -	input_len = 2048;
>  -	input = rtw_zmalloc(input_len);
>  -	if (NULL == input)
>  -		return -ENOMEM;
>  -	if (copy_from_user(input, wdata.data.pointer, input_len)) {
>  -		err = -EFAULT;
>  -		goto exit;
>  -	}
>  -	ptr = input;
>  -	len = strlen(input);
>  -
>  -	sscanf(ptr, "%16s", cmdname);
>  -	cmdlen = strlen(cmdname);
>  -
>  -	/*  skip command string */
>  -	if (cmdlen > 0)
>  -		cmdlen += 1; /*  skip one space */
>  -	ptr += cmdlen;
>  -	len -= cmdlen;
>  -
>  -	priv = rtw_private_handler;
>  -	priv_args = rtw_private_args;
>  -	num_priv_args = ARRAY_SIZE(rtw_private_args);
>  -
>  -	if (num_priv_args == 0) {
>  -		err = -EOPNOTSUPP;
>  -		goto exit;
>  -	}
>  -
>  -	/* Search the correct ioctl */
>  -	k = -1;
>  -	while ((++k < num_priv_args) && strcmp(priv_args[k].name, cmdname));
>  -
>  -	/* If not found... */
>  -	if (k == num_priv_args) {
>  -		err = -EOPNOTSUPP;
>  -		goto exit;
>  -	}
>  -
>  -	/* Watch out for sub-ioctls ! */
>  -	if (priv_args[k].cmd < SIOCDEVPRIVATE) {
>  -		int j = -1;
>  -
>  -		/* Find the matching *real* ioctl */
>  -		while ((++j < num_priv_args) && ((priv_args[j].name[0] != '\0') ||
>  -			(priv_args[j].set_args != priv_args[k].set_args) ||
>  -			(priv_args[j].get_args != priv_args[k].get_args)));
>  -
>  -		/* If not found... */
>  -		if (j == num_priv_args) {
>  -			err = -EINVAL;
>  -			goto exit;
>  -		}
>  -
>  -		/* Save sub-ioctl number */
>  -		subcmd = priv_args[k].cmd;
>  -		/* Reserve one int (simplify alignment issues) */
>  -		offset = sizeof(__u32);
>  -		/* Use real ioctl definition from now on */
>  -		k = j;
>  -	}
>  -
>  -	buffer = rtw_zmalloc(4096);
>  -	if (NULL == buffer) {
>  -		err = -ENOMEM;
>  -		goto exit;
>  -	}
>  -
>  -	/* If we have to set some data */
>  -	if ((priv_args[k].set_args & IW_PRIV_TYPE_MASK) &&
>  -		(priv_args[k].set_args & IW_PRIV_SIZE_MASK)) {
>  -		u8 *str;
>  -
>  -		switch (priv_args[k].set_args & IW_PRIV_TYPE_MASK) {
>  -		case IW_PRIV_TYPE_BYTE:
>  -			/* Fetch args */
>  -			count = 0;
>  -			do {
>  -				str = strsep(&ptr, delim);
>  -				if (NULL == str)
>  -					break;
>  -				sscanf(str, "%i", &temp);
>  -				buffer[count++] = (u8)temp;
>  -			} while (1);
>  -			buffer_len = count;
>  -
>  -			/* Number of args to fetch */
>  -			wdata.data.length = count;
>  -			if (wdata.data.length > (priv_args[k].set_args & IW_PRIV_SIZE_MASK))
>  -				wdata.data.length = priv_args[k].set_args & IW_PRIV_SIZE_MASK;
>  -
>  -			break;
>  -
>  -		case IW_PRIV_TYPE_INT:
>  -			/* Fetch args */
>  -			count = 0;
>  -			do {
>  -				str = strsep(&ptr, delim);
>  -				if (NULL == str)
>  -					break;
>  -				sscanf(str, "%i", &temp);
>  -				((s32 *)buffer)[count++] = (s32)temp;
>  -			} while (1);
>  -			buffer_len = count * sizeof(s32);
>  -
>  -			/* Number of args to fetch */
>  -			wdata.data.length = count;
>  -			if (wdata.data.length > (priv_args[k].set_args & IW_PRIV_SIZE_MASK))
>  -				wdata.data.length = priv_args[k].set_args & IW_PRIV_SIZE_MASK;
>  -
>  -			break;
>  -
>  -		case IW_PRIV_TYPE_CHAR:
>  -			if (len > 0) {
>  -				/* Size of the string to fetch */
>  -				wdata.data.length = len;
>  -				if (wdata.data.length > (priv_args[k].set_args & IW_PRIV_SIZE_MASK))
>  -					wdata.data.length = priv_args[k].set_args & IW_PRIV_SIZE_MASK;
>  -
>  -				/* Fetch string */
>  -				memcpy(buffer, ptr, wdata.data.length);
>  -			} else {
>  -				wdata.data.length = 1;
>  -				buffer[0] = '\0';
>  -			}
>  -			buffer_len = wdata.data.length;
>  -			break;
>  -
>  -		default:
>  -			err = -1;
>  -			goto exit;
>  -		}
>  -
>  -		if ((priv_args[k].set_args & IW_PRIV_SIZE_FIXED) &&
>  -			(wdata.data.length != (priv_args[k].set_args & IW_PRIV_SIZE_MASK))) {
>  -			err = -EINVAL;
>  -			goto exit;
>  -		}
>  -	} else { /* if args to set */
>  -		wdata.data.length = 0L;
>  -	}
>  -
>  -	/* Those two tests are important. They define how the driver
>  -	* will have to handle the data */
>  -	if ((priv_args[k].set_args & IW_PRIV_SIZE_FIXED) &&
>  -		((get_priv_size(priv_args[k].set_args) + offset) <= IFNAMSIZ)) {
>  -		/* First case : all SET args fit within wrq */
>  -		if (offset)
>  -			wdata.mode = subcmd;
>  -		memcpy(wdata.name + offset, buffer, IFNAMSIZ - offset);
>  -	} else {
>  -		if ((priv_args[k].set_args == 0) &&
>  -			(priv_args[k].get_args & IW_PRIV_SIZE_FIXED) &&
>  -			(get_priv_size(priv_args[k].get_args) <= IFNAMSIZ)) {
>  -			/* Second case : no SET args, GET args fit within wrq */
>  -			if (offset)
>  -				wdata.mode = subcmd;
>  -		} else {
>  -			/* Third case : args won't fit in wrq, or variable number of args */
>  -			if (copy_to_user(wdata.data.pointer, buffer, buffer_len)) {
>  -				err = -EFAULT;
>  -				goto exit;
>  -			}
>  -			wdata.data.flags = subcmd;
>  -		}
>  -	}
>  -
>  -	kfree(input);
>  -	input = NULL;
>  -
>  -	extra_size = 0;
>  -	if (IW_IS_SET(priv_args[k].cmd)) {
>  -		/* Size of set arguments */
>  -		extra_size = get_priv_size(priv_args[k].set_args);
>  -
>  -		/* Does it fits in iwr ? */
>  -		if ((priv_args[k].set_args & IW_PRIV_SIZE_FIXED) &&
>  -			((extra_size + offset) <= IFNAMSIZ))
>  -			extra_size = 0;
>  -	} else {
>  -		/* Size of get arguments */
>  -		extra_size = get_priv_size(priv_args[k].get_args);
>  -
>  -		/* Does it fits in iwr ? */
>  -		if ((priv_args[k].get_args & IW_PRIV_SIZE_FIXED) &&
>  -			(extra_size <= IFNAMSIZ))
>  -			extra_size = 0;
>  -	}
>  -
>  -	if (extra_size == 0) {
>  -		extra = (u8 *)&wdata;
>  -		kfree(buffer);
>  -		buffer = NULL;
>  -	} else
>  -		extra = buffer;
>  -
>  -	handler = priv[priv_args[k].cmd - SIOCIWFIRSTPRIV];
>  -	err = handler(dev, NULL, &wdata, extra);
>  -
>  -	/* If we have to get some data */
>  -	if ((priv_args[k].get_args & IW_PRIV_TYPE_MASK) &&
>  -		(priv_args[k].get_args & IW_PRIV_SIZE_MASK)) {
>  -		int j;
>  -		int n = 0;	/* number of args */
>  -		u8 str[20] = {0};
>  -
>  -		/* Check where is the returned data */
>  -		if ((priv_args[k].get_args & IW_PRIV_SIZE_FIXED) &&
>  -			(get_priv_size(priv_args[k].get_args) <= IFNAMSIZ))
>  -			n = priv_args[k].get_args & IW_PRIV_SIZE_MASK;
>  -		else
>  -			n = wdata.data.length;
>  -
>  -		output = rtw_zmalloc(4096);
>  -		if (NULL == output) {
>  -			err =  -ENOMEM;
>  -			goto exit;
>  -		}
>  -
>  -		switch (priv_args[k].get_args & IW_PRIV_TYPE_MASK) {
>  -		case IW_PRIV_TYPE_BYTE:
>  -			/* Display args */
>  -			for (j = 0; j < n; j++) {
>  -				len = scnprintf(str, sizeof(str), "%d  ", extra[j]);
>  -				output_len = strlen(output);
>  -				if ((output_len + len + 1) > 4096) {
>  -					err = -E2BIG;
>  -					goto exit;
>  -				}
>  -				memcpy(output+output_len, str, len);
>  -			}
>  -			break;
>  -
>  -		case IW_PRIV_TYPE_INT:
>  -			/* Display args */
>  -			for (j = 0; j < n; j++) {
>  -				len = scnprintf(str, sizeof(str), "%d  ", ((__s32 *)extra)[j]);
>  -				output_len = strlen(output);
>  -				if ((output_len + len + 1) > 4096) {
>  -					err = -E2BIG;
>  -					goto exit;
>  -				}
>  -				memcpy(output+output_len, str, len);
>  -			}
>  -			break;
>  -
>  -		case IW_PRIV_TYPE_CHAR:
>  -			/* Display args */
>  -			memcpy(output, extra, n);
>  -			break;
>  -
>  -		default:
>  -			err = -1;
>  -			goto exit;
>  -		}
>  -
>  -		output_len = strlen(output) + 1;
>  -		wrq_data->data.length = output_len;
>  -		if (copy_to_user(wrq_data->data.pointer, output, output_len)) {
>  -			err = -EFAULT;
>  -			goto exit;
>  -		}
>  -	} else { /* if args to set */
>  -		wrq_data->data.length = 0;
>  -	}
>  -
>  -exit:
>  -	kfree(input);
>  -	kfree(buffer);
>  -	kfree(output);
>  -
>  -	return err;
>  -}
>  -
> + int rtw_siocdevprivate(struct net_device *dev, struct ifreq *rq,
> + 		       void __user *data, int cmd)
> + {
>  -	struct iwreq *wrq = (struct iwreq *)rq;
>  -
> + 	/* little hope of fixing this, better remove the whole function */
> + 	if (in_compat_syscall())
> + 		return -EOPNOTSUPP;
> + 
> + 	if (cmd != SIOCDEVPRIVATE)
> + 		return -EOPNOTSUPP;
> + 
>  -	return rtw_ioctl_wext_private(dev, &wrq->u);
> ++	return -EOPNOTSUPP;
> + }
> + 
>   int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
>   {
>   	struct iwreq *wrq = (struct iwreq *)rq;



Should all now be resolved in Linus's tree.

thanks,

greg k-h

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9EC54DB33
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 09:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiFPHFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 03:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiFPHFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 03:05:32 -0400
Received: from fallback11.mail.ru (fallback11.mail.ru [94.100.179.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568935BD16;
        Thu, 16 Jun 2022 00:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail4;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=3ao7ym9ZGyJkiog42juB6soK3+Xx+lZZszGiPur9fU4=;
        t=1655363127;x=1655968527; 
        b=dMRl4qjPWVr9oNMKhdFoxelxdlhI7wO/Pb/gWmrgnAjNvrIGeUn10tKyqQC+7+oVepwVFn6ELTNNW2qEvkS7NS7JntDoOPW0wZK0NWBMenJ9qD2ulf4VfiaQr4w0awJkWOJ5H0Nky+qQdpegWza0sxjVwsrO9/muIJvnmFuUMb5q1Lf0twQ8RRfRLgVnL4TcgoJpTW8vetJsQtq5XRcPT8tkzAQ7Gc6RoUxsc3mQ7WYGpDXUnD0fx0xEFJss1PBNXTXFlZHt7UIbUDhoW9C7tZK6Wxi7lvdd3FFmWz/7i21epy4tbW2Ot6xgZWAsZI1aicHEwcY3wcBx8hTZJWKn3A==;
Received: from [10.161.55.49] (port=47908 helo=smtpng1.i.mail.ru)
        by fallback11.m.smailru.net with esmtp (envelope-from <fido_max@inbox.ru>)
        id 1o1jZE-0001qz-RY; Thu, 16 Jun 2022 10:05:25 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail4;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=3ao7ym9ZGyJkiog42juB6soK3+Xx+lZZszGiPur9fU4=;
        t=1655363124;x=1655968524; 
        b=O/kwnUqaG24EJL4r4NzG+2HbGeICDiReERQFJ63t/UZ2WR5Rh4zkgN/P7f1ChEKKqtGrk2KReBIBAd/e4A8gMW/d3UszuAZbUvg/25mQGChAkbFWF2WxGUpZuGdNvvEaxAnTZ+LhtMfdG4MAA6E9L/Ut5eFqv3IwoD8bLPF1F1aR0P84V7Ke/FeQciPARF18n0nKLZvekBW+kQWo6H1CxECBAYpPQt1j4m9uChfgnLMQRVdfxfJc15RJxpcAWsNv9RRD+xoHkpyzqgsS0o76SpmYOVR4jHHXVa7/dV2XGhtswBemcAovAa3NnYmvvI58MMzJkpw7LxbjQ06DWxiYAA==;
Received: by smtpng1.m.smailru.net with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1o1jYx-0006fw-Bv; Thu, 16 Jun 2022 10:05:08 +0300
Message-ID: <94308180-5eb6-5327-4188-151c57944741@inbox.ru>
Date:   Thu, 16 Jun 2022 10:05:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v1 net-next] net: dsa: felix: update base time of
 time-aware shaper when adjusting PTP time
Content-Language: en-US
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, andrew@lunn.ch, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, yangbo.lu@nxp.com
References: <20220616064641.11905-1-xiaoliang.yang_1@nxp.com>
From:   Maxim Kochetkov <fido_max@inbox.ru>
In-Reply-To: <20220616064641.11905-1-xiaoliang.yang_1@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD97D44297578DBEB86154F2FD640FB217D6E2915693C7339E7182A05F538085040184275CC1862B34669402B347C66D11A548B711847D91F8BB9ABCFD23BD16216
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7ACBBB5686CDD3661EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006378D08D652E28591A78638F802B75D45FF36EB9D2243A4F8B5A6FCA7DBDB1FC311F39EFFDF887939037866D6147AF826D8F664FF0BA087D191BC2D609D5442C1586F9789CCF6C18C3F8528715B7D10C86878DA827A17800CE7E4DF6D1C10F22F599FA2833FD35BB23D9E625A9149C048EE33AC447995A7AD18F04B652EEC242312D2E47CDBA5A96583BD4B6F7A4D31EC0BC014FD901B82EE079FA2833FD35BB23D27C277FBC8AE2E8B3A703B70628EAD7BA471835C12D1D977C4224003CC8364762BB6847A3DEAEFB0F43C7A68FF6260569E8FC8737B5C2249EC8D19AE6D49635B68655334FD4449CB9ECD01F8117BC8BEAAAE862A0553A39223F8577A6DFFEA7C2C2559B29ED8195043847C11F186F3C59DAA53EE0834AAEE
X-8FC586DF: 6EFBBC1D9D64D975
X-C1DE0DAB: 9604B64F49C60606AD91A466A1DEF99B296C473AB1E14218C6CDE5D1141D2B1C55072F1313F499AD4DB64DB2D46D28F1F2AF54EA0132BD6EAD91A466A1DEF99B296C473AB1E14218B936CB490224F2464EEA7BD89490CAC0EDDA962BC3F61961
X-C8649E89: 4E36BF7865823D7055A7F0CF078B5EC49A30900B95165D3475FE4AA98865E235387F9E2E86DBDF0A4626ECBC3C28D782E81E58641EF9412EC614CD0814E6A7D21D7E09C32AA3244C85DCF47A73000982B50357DA333F1D8860759606DA2E136A4A5FEE14E26358B9
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojCCvLuneITNo5U/eLnWlphQ==
X-Mailru-Sender: 689FA8AB762F7393CC2E0F076E87284E19C9EE9456E7226CDD211C8C194ABF1998CC072019C18A892CA7F8C7C9492E1F2F5E575105D0B01ADBE2EF17B331888EEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: Ok
X-7564579A: B8F34718100C35BD
X-77F55803: 6242723A09DB00B47AE4952871AAFFF6F04C84B37B83C1BF508A1B5381C14D55049FFFDB7839CE9E44F84BB1FBFF2A547C1E60647DA420020D74B7805F66FE8EF5F3F606A5035D04
X-7FA49CB5: 0D63561A33F958A5F45275BF9F1622472AD136DA2172539FA2FCEA4862802874CACD7DF95DA8FC8BD5E8D9A59859A8B600E44CF7DE520BF0CC7F00164DA146DAFE8445B8C89999728AA50765F7900637FD2911E685725BF8389733CBF5DBD5E9C8A9BA7A39EFB766F5D81C698A659EA7CC7F00164DA146DA9985D098DBDEAEC8BC0ADEB1C81BB362F6B57BC7E6449061A352F6E88A58FB86F5D81C698A659EA775ECD9A6C639B01B78DA827A17800CE7A9D141641BA1E09E731C566533BA786AA5CC5B56E945C8DA
X-C1DE0DAB: 9604B64F49C60606AD91A466A1DEF99B296C473AB1E14218C6CDE5D1141D2B1CB721FD8C5FF1A48BF186B4BE37D16B5DD4F42F16CDE1C77AAD91A466A1DEF99B296C473AB1E14218B936CB490224F2464EEA7BD89490CAC0EDDA962BC3F61961
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojCCvLuneITNq4psKvbbBwJw==
X-Mailru-MI: 8000000000000800
X-Mras: Ok
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16.06.2022 09:46, Xiaoliang Yang wrote:
> When adjusting the PTP clock, the base time of the TAS configuration
> will become unreliable. We need reset the TAS configuration by using a
> new base time.
> 
> For example, if the driver gets a base time 0 of Qbv configuration from
> user, and current time is 20000. The driver will set the TAS base time
> to be 20000. After the PTP clock adjustment, the current time becomes
> 10000. If the TAS base time is still 20000, it will be a future time,
> and TAS entry list will stop running. Another example, if the current
> time becomes to be 10000000 after PTP clock adjust, a large time offset
> can cause the hardware to hang.
> 
> This patch introduces a tas_clock_adjust() function to reset the TAS
> module by using a new base time after the PTP clock adjustment. This can
> avoid issues above.
> 
> Due to PTP clock adjustment can occur at any time, it may conflict with
> the TAS configuration. We introduce a new TAS lock to serialize the
> access to the TAS registers.
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---
>   drivers/net/dsa/ocelot/felix_vsc9959.c | 83 ++++++++++++++++++++++++--
>   drivers/net/ethernet/mscc/ocelot.c     |  1 +
>   drivers/net/ethernet/mscc/ocelot_ptp.c | 12 +++-
>   include/soc/mscc/ocelot.h              |  7 +++
>   4 files changed, 95 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 570d0204b7be..dd9085ae0922 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -1196,10 +1196,13 @@ static void vsc9959_tas_gcl_set(struct ocelot *ocelot, const u32 gcl_ix,
>   static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
>   				    struct tc_taprio_qopt_offload *taprio)
>   {
> +	struct ocelot_port *ocelot_port = ocelot->ports[port];
>   	struct timespec64 base_ts;
>   	int ret, i;
>   	u32 val;
>   
> +	mutex_lock(&ocelot->tas_lock);
> +
>   	if (!taprio->enable) {
>   		ocelot_rmw_rix(ocelot,
>   			       QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF),
> @@ -1207,15 +1210,20 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
>   			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
>   			       QSYS_TAG_CONFIG, port);
>   
> +		mutex_unlock(&ocelot->tas_lock);
>   		return 0;
>   	}
>   
>   	if (taprio->cycle_time > NSEC_PER_SEC ||
> -	    taprio->cycle_time_extension >= NSEC_PER_SEC)
> -		return -EINVAL;
> +	    taprio->cycle_time_extension >= NSEC_PER_SEC) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
>   
> -	if (taprio->num_entries > VSC9959_TAS_GCL_ENTRY_MAX)
> -		return -ERANGE;
> +	if (taprio->num_entries > VSC9959_TAS_GCL_ENTRY_MAX) {
> +		ret = -ERANGE;
> +		goto err;
> +	}
>   
>   	/* Enable guard band. The switch will schedule frames without taking
>   	 * their length into account. Thus we'll always need to enable the
> @@ -1236,8 +1244,10 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
>   	 * config is pending, need reset the TAS module
>   	 */
>   	val = ocelot_read(ocelot, QSYS_PARAM_STATUS_REG_8);
> -	if (val & QSYS_PARAM_STATUS_REG_8_CONFIG_PENDING)
> -		return  -EBUSY;
> +	if (val & QSYS_PARAM_STATUS_REG_8_CONFIG_PENDING) {
> +		ret = -EBUSY;
> +		goto err;
> +	}
>   
>   	ocelot_rmw_rix(ocelot,
>   		       QSYS_TAG_CONFIG_ENABLE |
> @@ -1248,6 +1258,8 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
>   		       QSYS_TAG_CONFIG_SCH_TRAFFIC_QUEUES_M,
>   		       QSYS_TAG_CONFIG, port);
>   
> +	ocelot_port->base_time = taprio->base_time;
> +
>   	vsc9959_new_base_time(ocelot, taprio->base_time,
>   			      taprio->cycle_time, &base_ts);
>   	ocelot_write(ocelot, base_ts.tv_nsec, QSYS_PARAM_CFG_REG_1);
> @@ -1271,9 +1283,67 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
>   				 !(val & QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE),
>   				 10, 100000);
>   
> +err:
> +	mutex_unlock(&ocelot->tas_lock);
> +
>   	return ret;
>   }
>   
> +static void vsc9959_tas_clock_adjust(struct ocelot *ocelot)
> +{
> +	struct ocelot_port *ocelot_port;
> +	struct timespec64 base_ts;
> +	u64 cycletime;
> +	int port;
> +	u32 val;
> +
> +	mutex_lock(&ocelot->tas_lock);
> +
> +	for (port = 0; port < ocelot->num_phys_ports; port++) {
> +		val = ocelot_read_rix(ocelot, QSYS_TAG_CONFIG, port);
> +		if (!(val & QSYS_TAG_CONFIG_ENABLE))
> +			continue;
> +
> +		ocelot_rmw(ocelot,
> +			   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM(port),
> +			   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM_M,
> +			   QSYS_TAS_PARAM_CFG_CTRL);
> +
> +		ocelot_rmw_rix(ocelot,
> +			       QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF),
> +			       QSYS_TAG_CONFIG_ENABLE |
> +			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
> +			       QSYS_TAG_CONFIG, port);
> +
> +		cycletime = ocelot_read(ocelot, QSYS_PARAM_CFG_REG_4);
> +		ocelot_port = ocelot->ports[port];
> +
> +		vsc9959_new_base_time(ocelot, ocelot_port->base_time,
> +				      cycletime, &base_ts);
> +
> +		ocelot_write(ocelot, base_ts.tv_nsec, QSYS_PARAM_CFG_REG_1);
> +		ocelot_write(ocelot, lower_32_bits(base_ts.tv_sec),
> +			     QSYS_PARAM_CFG_REG_2);
> +		val = upper_32_bits(base_ts.tv_sec);
> +		ocelot_rmw(ocelot,
> +			   QSYS_PARAM_CFG_REG_3_BASE_TIME_SEC_MSB(val),
> +			   QSYS_PARAM_CFG_REG_3_BASE_TIME_SEC_MSB_M,
> +			   QSYS_PARAM_CFG_REG_3);
> +
> +		ocelot_rmw(ocelot, QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE,
> +			   QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE,
> +			   QSYS_TAS_PARAM_CFG_CTRL);
> +
> +		ocelot_rmw_rix(ocelot,
> +			       QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF) |
> +			       QSYS_TAG_CONFIG_ENABLE,
> +			       QSYS_TAG_CONFIG_ENABLE |
> +			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
> +			       QSYS_TAG_CONFIG, port);
> +	}
> +	mutex_unlock(&ocelot->tas_lock);
> +}
> +
>   static int vsc9959_qos_port_cbs_set(struct dsa_switch *ds, int port,
>   				    struct tc_cbs_qopt_offload *cbs_qopt)
>   {
> @@ -2210,6 +2280,7 @@ static const struct ocelot_ops vsc9959_ops = {
>   	.psfp_filter_del	= vsc9959_psfp_filter_del,
>   	.psfp_stats_get		= vsc9959_psfp_stats_get,
>   	.cut_through_fwd	= vsc9959_cut_through_fwd,
> +	.tas_clock_adjust	= vsc9959_tas_clock_adjust,
>   };
>   
>   static const struct felix_info felix_info_vsc9959 = {
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 8da7e25a47c9..d4649e4ee0e7 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -3367,6 +3367,7 @@ int ocelot_init(struct ocelot *ocelot)
>   	mutex_init(&ocelot->ptp_lock);
>   	mutex_init(&ocelot->mact_lock);
>   	mutex_init(&ocelot->fwd_domain_lock);
> +	mutex_init(&ocelot->tas_lock);
>   	spin_lock_init(&ocelot->ptp_clock_lock);
>   	spin_lock_init(&ocelot->ts_id_lock);
>   	snprintf(queue_name, sizeof(queue_name), "%s-stats",
> diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
> index 87ad2137ba06..522fdc38d4d0 100644
> --- a/drivers/net/ethernet/mscc/ocelot_ptp.c
> +++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
> @@ -72,15 +72,19 @@ int ocelot_ptp_settime64(struct ptp_clock_info *ptp,
>   	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
>   
>   	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
> +
> +	if (ocelot->ops->tas_clock_adjust)
> +		ocelot->ops->tas_clock_adjust(ocelot);
> +
>   	return 0;
>   }
>   EXPORT_SYMBOL(ocelot_ptp_settime64);
>   
>   int ocelot_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>   {
> +	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
> +
>   	if (delta > -(NSEC_PER_SEC / 2) && delta < (NSEC_PER_SEC / 2)) {
> -		struct ocelot *ocelot = container_of(ptp, struct ocelot,
> -						     ptp_info);
>   		unsigned long flags;
>   		u32 val;
>   
> @@ -117,6 +121,10 @@ int ocelot_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>   
>   		ocelot_ptp_settime64(ptp, &ts);
>   	}
> +
> +	if (ocelot->ops->tas_clock_adjust)
> +		ocelot->ops->tas_clock_adjust(ocelot);
> +

Here tas_clock_adjust() may be called twice (first from 
ocelot_ptp_settime64() )

>   	return 0;
>   }
>   EXPORT_SYMBOL(ocelot_ptp_adjtime);
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 5f88385a7748..3737570116c3 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -575,6 +575,7 @@ struct ocelot_ops {
>   	int (*psfp_stats_get)(struct ocelot *ocelot, struct flow_cls_offload *f,
>   			      struct flow_stats *stats);
>   	void (*cut_through_fwd)(struct ocelot *ocelot);
> +	void (*tas_clock_adjust)(struct ocelot *ocelot);
>   };
>   
>   struct ocelot_vcap_policer {
> @@ -691,6 +692,9 @@ struct ocelot_port {
>   	int				bridge_num;
>   
>   	int				speed;
> +
> +	/* Store the AdminBaseTime of EST fetched from userspace. */
> +	s64				base_time;
>   };
>   
>   struct ocelot {
> @@ -757,6 +761,9 @@ struct ocelot {
>   	/* Lock for serializing forwarding domain changes */
>   	struct mutex			fwd_domain_lock;
>   
> +	/* Lock for serializing Time-Aware Shaper changes */
> +	struct mutex			tas_lock;
> +
Why do we need extra mutex? ocelot_ptp_settime64() and 
ocelot_ptp_adjtime() already uses 
spin_lock_irqsave(&ocelot->ptp_clock_lock, flags)

>   	struct workqueue_struct		*owq;
>   
>   	u8				ptp:1;

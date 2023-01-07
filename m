Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CE6660D0F
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 09:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjAGIqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 03:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjAGIqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 03:46:42 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965DA6144D
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 00:46:41 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so2596790wms.4
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 00:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m7I0g3RUNnmlRDA9bESwDF7S68Xwa5pRIsZ/jUo0xnc=;
        b=hJxmMu5E8Hx9dSxhuSDuqvb5fGiI7tvJt80P15TDMrQS6Y2ZRbrwgPcyrFbOfuc/dF
         PWMNEfQw8UwF6Zr75VE6JfP9+9YwMMTc7kW6QaysXxb6zZ37n89b63/bfTnPnrjX2kMD
         91aVnimmiX9g4j3vURU4GSxI0s1nHz25bg8V2/LDDtU901AbrTY0qurlBYKhvXAlAKyQ
         ll5yPrV4Su/+kKpfe25yJNUnKNgio4WsctDxvEnKGJA32XD0j1Wav+VsnB7lua4OTDxC
         A0x1OCbQBJDG1HsjLNnCKPl55TUkXrkdry0aXzEE17l9Zn33CJaXXNiVK3icx9FBhQAr
         EaDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m7I0g3RUNnmlRDA9bESwDF7S68Xwa5pRIsZ/jUo0xnc=;
        b=EV80OVq9ln4Bc1srp68JG7yudOvryX9ZF2LnI4QXIqN8DUjkPUTt+QBwXnlR/o0PtY
         MV81CCyhyPwhgCtf1+qyW845wmaUEGaGGsrit33jRlQwdMiqfyAxOnCkaWuO2Rj2tPpD
         MDsBs/gUFAD+nN/pSluyO7vLfJnyDZZc7wHdFTtnB+MI4Rqw/QuLgA+YJ946gKr6tUHO
         dEWKCtKNBUIm59MoPWmXXlMLVyGOu+Zp1LBwL+Yy0eLyXGTq1iwI9fAmvqu3+cjsI7y5
         YKeanOXUzOii6204+rv9mWhkLhxuqjnR3YQEzASAmGBfcPaZPvPYogP+UAoGIR4CJe0O
         v1Mw==
X-Gm-Message-State: AFqh2kqiOv2FJoXsyVemHJmZYNM8YQ+RipSTBW3OxvKyAvGCHLBS5eQU
        ukyjMiYolWb7rXI4rs8hRzcGT0RrfjJHd4rJ
X-Google-Smtp-Source: AMrXdXtc7XYGRFIQ8WaPw65cvcqtQCHPTHJD8gwVfNidnhZ4kvPt3p0hkTua3kVXQjYOh+rNU7NBjA==
X-Received: by 2002:a1c:4c12:0:b0:3c6:e63e:89a6 with SMTP id z18-20020a1c4c12000000b003c6e63e89a6mr41401326wmf.2.1673081200188;
        Sat, 07 Jan 2023 00:46:40 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id c13-20020adffb0d000000b00241fde8fe04sm3276487wrr.7.2023.01.07.00.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 00:46:39 -0800 (PST)
Date:   Sat, 7 Jan 2023 11:46:32 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     oe-kbuild@lists.linux.dev,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: Re: [PATCH net-next v3 9/9] tsnep: Add XDP RX support
Message-ID: <202301071414.ritICMHu-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104194132.24637-10-gerhard@engleder-embedded.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gerhard,

url:    https://github.com/intel-lab-lkp/linux/commits/Gerhard-Engleder/tsnep-Use-spin_lock_bh-for-TX/20230105-034351
patch link:    https://lore.kernel.org/r/20230104194132.24637-10-gerhard%40engleder-embedded.com
patch subject: [PATCH net-next v3 9/9] tsnep: Add XDP RX support
config: arc-randconfig-m041-20230106
compiler: arc-elf-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>

New smatch warnings:
drivers/net/ethernet/engleder/tsnep_main.c:641 tsnep_xdp_xmit_back() warn: signedness bug returning '(-14)'

vim +641 drivers/net/ethernet/engleder/tsnep_main.c

dd23b834a352b5 Gerhard Engleder 2023-01-04  631  static bool tsnep_xdp_xmit_back(struct tsnep_adapter *adapter,
                                                        ^^^^
dd23b834a352b5 Gerhard Engleder 2023-01-04  632  				struct xdp_buff *xdp)
dd23b834a352b5 Gerhard Engleder 2023-01-04  633  {
dd23b834a352b5 Gerhard Engleder 2023-01-04  634  	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
dd23b834a352b5 Gerhard Engleder 2023-01-04  635  	int cpu = smp_processor_id();
dd23b834a352b5 Gerhard Engleder 2023-01-04  636  	struct netdev_queue *nq;
dd23b834a352b5 Gerhard Engleder 2023-01-04  637  	int queue;
dd23b834a352b5 Gerhard Engleder 2023-01-04  638  	bool xmit;
dd23b834a352b5 Gerhard Engleder 2023-01-04  639  
dd23b834a352b5 Gerhard Engleder 2023-01-04  640  	if (unlikely(!xdpf))
dd23b834a352b5 Gerhard Engleder 2023-01-04 @641  		return -EFAULT;

return false?

dd23b834a352b5 Gerhard Engleder 2023-01-04  642  
dd23b834a352b5 Gerhard Engleder 2023-01-04  643  	queue = cpu % adapter->num_tx_queues;
dd23b834a352b5 Gerhard Engleder 2023-01-04  644  	nq = netdev_get_tx_queue(adapter->netdev, queue);
dd23b834a352b5 Gerhard Engleder 2023-01-04  645  
dd23b834a352b5 Gerhard Engleder 2023-01-04  646  	__netif_tx_lock(nq, cpu);
dd23b834a352b5 Gerhard Engleder 2023-01-04  647  
dd23b834a352b5 Gerhard Engleder 2023-01-04  648  	/* Avoid transmit queue timeout since we share it with the slow path */
dd23b834a352b5 Gerhard Engleder 2023-01-04  649  	txq_trans_cond_update(nq);
dd23b834a352b5 Gerhard Engleder 2023-01-04  650  
dd23b834a352b5 Gerhard Engleder 2023-01-04  651  	xmit = tsnep_xdp_xmit_frame_ring(xdpf, &adapter->tx[queue],
dd23b834a352b5 Gerhard Engleder 2023-01-04  652  					 TSNEP_TX_TYPE_XDP_TX);
dd23b834a352b5 Gerhard Engleder 2023-01-04  653  
dd23b834a352b5 Gerhard Engleder 2023-01-04  654  	__netif_tx_unlock(nq);
dd23b834a352b5 Gerhard Engleder 2023-01-04  655  
dd23b834a352b5 Gerhard Engleder 2023-01-04  656  	return xmit;
dd23b834a352b5 Gerhard Engleder 2023-01-04  657  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests


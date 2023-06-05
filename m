Return-Path: <netdev+bounces-7822-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B453721B98
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 03:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EE7C281057
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 01:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AB75389;
	Mon,  5 Jun 2023 01:39:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5DB384
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 01:39:57 +0000 (UTC)
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A53ED
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 18:39:53 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso3923894a12.1
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 18:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20221208.gappssmtp.com; s=20221208; t=1685929193; x=1688521193;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q0yGzeugXA018CGI3jdJa9ggtbGg4FgjeukxvDXa6aw=;
        b=a8RytaVVUs/Yhbyi/f0z3qSZzAiLAqITrkSUXiZQYtvoFBiB/q1FFW8xiQe+uGEigQ
         DSStzNZx41aoQ83IKxIxQ8tDNPqFvh95xJu3RE/RyMr70TEACdW4B8WGZirISE1lpzAH
         f7Vh1IA+S91g9BND+YANPlmD/q+KBqxX6JYZ9x90u36MaCWahJv+AWNxMFOpjiqSQs7a
         7ryN35KF50BbPRTLwMp8cCP+VnvDJDRQ3o11wtLqwmJU+mgSRXJS82qIGnUxL5h6kh3K
         LCReNyMCCHv5AeQgJEa7WDmHsjDx1GQuDqOHm6x32HMe3NbZiNx8sarpmZMXj2o5usAv
         4cvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685929193; x=1688521193;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0yGzeugXA018CGI3jdJa9ggtbGg4FgjeukxvDXa6aw=;
        b=jNE1C2EdTkwOZ7d3D/iAt1oALo8p/R32FhEvaHDPAJa2dyoHO3TB+TGQHuAJcw0+zD
         igeMP7fOpjZegrj/kWuf0O9/pgJ3TcIFvmVjI0V7rA3GDSps/ZXbXhmdTW/MN4w7UWT1
         o2eVcZnXPaK1TudoyUfha5mssYAb66YNW3fW4fH2MJyD578xVIPQHCSu3N/Jctx9OUmX
         tvXr1OKGfNOGfVpSPDrBy0Fuhv9+tkUX7LT2pMF5vZKjwOcyDYyl4EzBmIG/HrWSR+jJ
         tKpwTNVRwk8qYA5P9n9hq+SGPhgYUyhxTgw96VnUEiBCPYR5IeNHDp8tIXwpnvggjKsV
         GC6Q==
X-Gm-Message-State: AC+VfDyQ9ZCzFVwKbv+kwlAJiTeGQy5R9M5JcylVv0UXHjS2UvYSu/KC
	brusgQmEC/kf9vDgq20SPgXwsrQvyT+hOsU+KgE=
X-Google-Smtp-Source: ACHHUZ6HlAUTYtjcOjAfYi3s0qxeOx9fj6rl+Z7B7Gdv7sPS7ACwggUnXbQq2THero50dHHdSJ41CQ==
X-Received: by 2002:a05:6a21:118a:b0:10d:5c7:6608 with SMTP id oj10-20020a056a21118a00b0010d05c76608mr5301355pzb.30.1685929192855;
        Sun, 04 Jun 2023 18:39:52 -0700 (PDT)
Received: from [10.16.161.199] (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id i14-20020a63d44e000000b00543ad78e3bdsm1006764pgj.16.2023.06.04.18.39.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jun 2023 18:39:52 -0700 (PDT)
Message-ID: <0c163750-10ef-76fb-d0f7-9afe4564f21d@igel.co.jp>
Date: Mon, 5 Jun 2023 10:39:49 +0900
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH v4 1/1] vringh: IOMEM support
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>, kernel test robot <lkp@intel.com>
Cc: Jason Wang <jasowang@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
 oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20230602055211.309960-2-mie@igel.co.jp>
 <202306021725.3otSfXPF-lkp@intel.com>
 <20230602065929-mutt-send-email-mst@kernel.org>
From: Shunsuke Mie <mie@igel.co.jp>
In-Reply-To: <20230602065929-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 2023/06/02 19:59, Michael S. Tsirkin wrote:
> On Fri, Jun 02, 2023 at 05:56:12PM +0800, kernel test robot wrote:
>> Hi Shunsuke,
>>
>> kernel test robot noticed the following build warnings:
>>
>> [auto build test WARNING on mst-vhost/linux-next]
>> [also build test WARNING on linus/master horms-ipvs/master v6.4-rc4 next-20230602]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use '--base' as documented in
>> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>>
>> url:    https://github.com/intel-lab-lkp/linux/commits/Shunsuke-Mie/vringh-IOMEM-support/20230602-135351
>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
>> patch link:    https://lore.kernel.org/r/20230602055211.309960-2-mie%40igel.co.jp
>> patch subject: [PATCH v4 1/1] vringh: IOMEM support
>> config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20230602/202306021725.3otSfXPF-lkp@intel.com/config)
>> compiler: alpha-linux-gcc (GCC) 12.3.0
>> reproduce (this is a W=1 build):
>>          mkdir -p ~/bin
>>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>          chmod +x ~/bin/make.cross
>>          # https://github.com/intel-lab-lkp/linux/commit/de2a1f5220c32e953400f225aba6bd294a8d41b8
>>          git remote add linux-review https://github.com/intel-lab-lkp/linux
>>          git fetch --no-tags linux-review Shunsuke-Mie/vringh-IOMEM-support/20230602-135351
>>          git checkout de2a1f5220c32e953400f225aba6bd294a8d41b8
>>          # save the config file
>>          mkdir build_dir && cp config build_dir/.config
>>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=alpha olddefconfig
>>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash drivers/
>>
>> If you fix the issue, kindly add following tag where applicable
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Closes: https://lore.kernel.org/oe-kbuild-all/202306021725.3otSfXPF-lkp@intel.com/
>>
>> All warnings (new ones prefixed by >>):
>>
>>>> drivers/vhost/vringh.c:1661:5: warning: no previous prototype for 'vringh_init_iomem' [-Wmissing-prototypes]
>>      1661 | int vringh_init_iomem(struct vringh *vrh, u64 features, unsigned int num,
>>           |     ^~~~~~~~~~~~~~~~~
>>>> drivers/vhost/vringh.c:1683:5: warning: no previous prototype for 'vringh_getdesc_iomem' [-Wmissing-prototypes]
>>      1683 | int vringh_getdesc_iomem(struct vringh *vrh, struct vringh_kiov *riov,
>>           |     ^~~~~~~~~~~~~~~~~~~~
>>>> drivers/vhost/vringh.c:1714:9: warning: no previous prototype for 'vringh_iov_pull_iomem' [-Wmissing-prototypes]
>>      1714 | ssize_t vringh_iov_pull_iomem(struct vringh *vrh, struct vringh_kiov *riov,
>>           |         ^~~~~~~~~~~~~~~~~~~~~
>>>> drivers/vhost/vringh.c:1729:9: warning: no previous prototype for 'vringh_iov_push_iomem' [-Wmissing-prototypes]
>>      1729 | ssize_t vringh_iov_push_iomem(struct vringh *vrh, struct vringh_kiov *wiov,
>>           |         ^~~~~~~~~~~~~~~~~~~~~
>>>> drivers/vhost/vringh.c:1744:6: warning: no previous prototype for 'vringh_abandon_iomem' [-Wmissing-prototypes]
>>      1744 | void vringh_abandon_iomem(struct vringh *vrh, unsigned int num)
>>           |      ^~~~~~~~~~~~~~~~~~~~
>>>> drivers/vhost/vringh.c:1759:5: warning: no previous prototype for 'vringh_complete_iomem' [-Wmissing-prototypes]
>>      1759 | int vringh_complete_iomem(struct vringh *vrh, u16 head, u32 len)
>>           |     ^~~~~~~~~~~~~~~~~~~~~
>>>> drivers/vhost/vringh.c:1777:6: warning: no previous prototype for 'vringh_notify_enable_iomem' [-Wmissing-prototypes]
>>      1777 | bool vringh_notify_enable_iomem(struct vringh *vrh)
>>           |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> drivers/vhost/vringh.c:1790:6: warning: no previous prototype for 'vringh_notify_disable_iomem' [-Wmissing-prototypes]
>>      1790 | void vringh_notify_disable_iomem(struct vringh *vrh)
>>           |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> drivers/vhost/vringh.c:1802:5: warning: no previous prototype for 'vringh_need_notify_iomem' [-Wmissing-prototypes]
>>      1802 | int vringh_need_notify_iomem(struct vringh *vrh)
>>           |     ^~~~~~~~~~~~~~~~~~~~~~~~
>>
>>
>> vim +/vringh_init_iomem +1661 drivers/vhost/vringh.c
>
> You probably should put the relevant code within ifdef.

I should'v removed a ifdef/endif from a header file, vringh.h.
I'll fix it.

>
>>    1647	
>>    1648	/**
>>    1649	 * vringh_init_iomem - initialize a vringh for a vring on io-memory.
>>    1650	 * @vrh: the vringh to initialize.
>>    1651	 * @features: the feature bits for this ring.
>>    1652	 * @num: the number of elements.
>>    1653	 * @weak_barriers: true if we only need memory barriers, not I/O.
>>    1654	 * @desc: the userspace descriptor pointer.
>>    1655	 * @avail: the userspace avail pointer.
>>    1656	 * @used: the userspace used pointer.
>>    1657	 *
>>    1658	 * Returns an error if num is invalid: you should check pointers
>>    1659	 * yourself!
>>    1660	 */
>>> 1661	int vringh_init_iomem(struct vringh *vrh, u64 features, unsigned int num,
>>    1662			      bool weak_barriers, struct vring_desc *desc,
>>    1663			      struct vring_avail *avail, struct vring_used *used)
>>    1664	{
>>    1665		return vringh_init_kern(vrh, features, num, weak_barriers, desc, avail,
>>    1666					used);
>>    1667	}
>>    1668	EXPORT_SYMBOL(vringh_init_iomem);
>>    1669	
>>    1670	/**
>>    1671	 * vringh_getdesc_iomem - get next available descriptor from vring on io-memory.
>>    1672	 * @vrh: the vring on io-memory.
>>    1673	 * @riov: where to put the readable descriptors (or NULL)
>>    1674	 * @wiov: where to put the writable descriptors (or NULL)
>>    1675	 * @head: head index we received, for passing to vringh_complete_iomem().
>>    1676	 * @gfp: flags for allocating larger riov/wiov.
>>    1677	 *
>>    1678	 * Returns 0 if there was no descriptor, 1 if there was, or -errno.
>>    1679	 *
>>    1680	 * There some notes, and those are same with vringh_getdesc_kern(). Please see
>>    1681	 * it.
>>    1682	 */
>>> 1683	int vringh_getdesc_iomem(struct vringh *vrh, struct vringh_kiov *riov,
>>    1684				 struct vringh_kiov *wiov, u16 *head, gfp_t gfp)
>>    1685	{
>>    1686		int err;
>>    1687	
>>    1688		err = __vringh_get_head(vrh, getu16_iomem, &vrh->last_avail_idx);
>>    1689		if (err < 0)
>>    1690			return err;
>>    1691	
>>    1692		/* Empty... */
>>    1693		if (err == vrh->vring.num)
>>    1694			return 0;
>>    1695	
>>    1696		*head = err;
>>    1697		err = __vringh_iov(vrh, *head, riov, wiov, no_range_check, NULL, gfp,
>>    1698				   copydesc_iomem);
>>    1699		if (err)
>>    1700			return err;
>>    1701	
>>    1702		return 1;
>>    1703	}
>>    1704	EXPORT_SYMBOL(vringh_getdesc_iomem);
>>    1705	
>>    1706	/**
>>    1707	 * vringh_iov_pull_iomem - copy bytes from vring_iov.
>>    1708	 * @riov: the riov as passed to vringh_getdesc_iomem() (updated as we consume)
>>    1709	 * @dst: the place to copy.
>>    1710	 * @len: the maximum length to copy.
>>    1711	 *
>>    1712	 * Returns the bytes copied <= len or a negative errno.
>>    1713	 */
>>> 1714	ssize_t vringh_iov_pull_iomem(struct vringh *vrh, struct vringh_kiov *riov,
>>    1715				      void *dst, size_t len)
>>    1716	{
>>    1717		return vringh_iov_xfer(vrh, riov, dst, len, xfer_from_iomem);
>>    1718	}
>>    1719	EXPORT_SYMBOL(vringh_iov_pull_iomem);
>>    1720	
>>    1721	/**
>>    1722	 * vringh_iov_push_iomem - copy bytes into vring_iov.
>>    1723	 * @wiov: the wiov as passed to vringh_getdesc_iomem() (updated as we consume)
>>    1724	 * @src: the place to copy from.
>>    1725	 * @len: the maximum length to copy.
>>    1726	 *
>>    1727	 * Returns the bytes copied <= len or a negative errno.
>>    1728	 */
>>> 1729	ssize_t vringh_iov_push_iomem(struct vringh *vrh, struct vringh_kiov *wiov,
>>    1730				      const void *src, size_t len)
>>    1731	{
>>    1732		return vringh_iov_xfer(vrh, wiov, (void *)src, len, xfer_to_iomem);
>>    1733	}
>>    1734	EXPORT_SYMBOL(vringh_iov_push_iomem);
>>    1735	
>>    1736	/**
>>    1737	 * vringh_abandon_iomem - we've decided not to handle the descriptor(s).
>>    1738	 * @vrh: the vring.
>>    1739	 * @num: the number of descriptors to put back (ie. num
>>    1740	 *	 vringh_getdesc_iomem() to undo).
>>    1741	 *
>>    1742	 * The next vringh_get_kern() will return the old descriptor(s) again.
>>    1743	 */
>>> 1744	void vringh_abandon_iomem(struct vringh *vrh, unsigned int num)
>>    1745	{
>>    1746		vringh_abandon_kern(vrh, num);
>>    1747	}
>>    1748	EXPORT_SYMBOL(vringh_abandon_iomem);
>>    1749	
>>    1750	/**
>>    1751	 * vringh_complete_iomem - we've finished with descriptor, publish it.
>>    1752	 * @vrh: the vring.
>>    1753	 * @head: the head as filled in by vringh_getdesc_iomem().
>>    1754	 * @len: the length of data we have written.
>>    1755	 *
>>    1756	 * You should check vringh_need_notify_iomem() after one or more calls
>>    1757	 * to this function.
>>    1758	 */
>>> 1759	int vringh_complete_iomem(struct vringh *vrh, u16 head, u32 len)
>>    1760	{
>>    1761		struct vring_used_elem used;
>>    1762	
>>    1763		used.id = cpu_to_vringh32(vrh, head);
>>    1764		used.len = cpu_to_vringh32(vrh, len);
>>    1765	
>>    1766		return __vringh_complete(vrh, &used, 1, putu16_iomem, putused_iomem);
>>    1767	}
>>    1768	EXPORT_SYMBOL(vringh_complete_iomem);
>>    1769	
>>    1770	/**
>>    1771	 * vringh_notify_enable_iomem - we want to know if something changes.
>>    1772	 * @vrh: the vring.
>>    1773	 *
>>    1774	 * This always enables notifications, but returns false if there are
>>    1775	 * now more buffers available in the vring.
>>    1776	 */
>>> 1777	bool vringh_notify_enable_iomem(struct vringh *vrh)
>>    1778	{
>>    1779		return __vringh_notify_enable(vrh, getu16_iomem, putu16_iomem);
>>    1780	}
>>    1781	EXPORT_SYMBOL(vringh_notify_enable_iomem);
>>    1782	
>>    1783	/**
>>    1784	 * vringh_notify_disable_iomem - don't tell us if something changes.
>>    1785	 * @vrh: the vring.
>>    1786	 *
>>    1787	 * This is our normal running state: we disable and then only enable when
>>    1788	 * we're going to sleep.
>>    1789	 */
>>> 1790	void vringh_notify_disable_iomem(struct vringh *vrh)
>>    1791	{
>>    1792		__vringh_notify_disable(vrh, putu16_iomem);
>>    1793	}
>>    1794	EXPORT_SYMBOL(vringh_notify_disable_iomem);
>>    1795	
>>    1796	/**
>>    1797	 * vringh_need_notify_iomem - must we tell the other side about used buffers?
>>    1798	 * @vrh: the vring we've called vringh_complete_iomem() on.
>>    1799	 *
>>    1800	 * Returns -errno or 0 if we don't need to tell the other side, 1 if we do.
>>    1801	 */
>>> 1802	int vringh_need_notify_iomem(struct vringh *vrh)
>>    1803	{
>>    1804		return __vringh_need_notify(vrh, getu16_iomem);
>>    1805	}
>>    1806	EXPORT_SYMBOL(vringh_need_notify_iomem);
>>    1807	
>>
>> -- 
>> 0-DAY CI Kernel Test Service
>> https://github.com/intel/lkp-tests/wiki

Best regards,

Shunsuke



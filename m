Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174C0440811
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 10:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhJ3IyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 04:54:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:38297 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230427AbhJ3Ix7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 04:53:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="210859261"
X-IronPort-AV: E=Sophos;i="5.87,194,1631602800"; 
   d="gz'50?scan'50,208,50";a="210859261"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2021 01:51:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,194,1631602800"; 
   d="gz'50?scan'50,208,50";a="466771092"
Received: from lkp-server02.sh.intel.com (HELO c20d8bc80006) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 30 Oct 2021 01:51:26 -0700
Received: from kbuild by c20d8bc80006 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mgk5F-0001Cx-8R; Sat, 30 Oct 2021 08:51:25 +0000
Date:   Sat, 30 Oct 2021 16:50:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org, jiri@resnulli.us,
        leon@kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 4/4] ethtool: don't drop the rtnl_lock half way
 thru the ioctl
Message-ID: <202110301653.Sl8SFaPC-lkp@intel.com>
References: <20211030040611.1751638-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20211030040611.1751638-5-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jakub,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Jakub-Kicinski/improve-ethtool-rtnl-vs-devlink-locking/20211030-120714
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 28131d896d6d316bc1f6f305d1a9ed6d96c3f2a1
config: ia64-defconfig (attached as .config)
compiler: ia64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/1ff3b7575e0d00813e134dd4945e5ccab234f2aa
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jakub-Kicinski/improve-ethtool-rtnl-vs-devlink-locking/20211030-120714
        git checkout 1ff3b7575e0d00813e134dd4945e5ccab234f2aa
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross ARCH=ia64 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/ethtool/ioctl.c: In function 'dev_ethtool':
>> net/ethtool/ioctl.c:3049:63: error: passing argument 1 of 'devlink_compat_flash_update' from incompatible pointer type [-Werror=incompatible-pointer-types]
    3049 |                         rc = devlink_compat_flash_update(state->devlink,
         |                                                          ~~~~~^~~~~~~~~
         |                                                               |
         |                                                               struct devlink *
   In file included from net/ethtool/ioctl.c:28:
   include/net/devlink.h:1757:48: note: expected 'struct net_device *' but argument is of type 'struct devlink *'
    1757 | devlink_compat_flash_update(struct net_device *dev, const char *file_name)
         |                             ~~~~~~~~~~~~~~~~~~~^~~
>> net/ethtool/ioctl.c:3054:61: error: passing argument 1 of 'devlink_compat_running_version' from incompatible pointer type [-Werror=incompatible-pointer-types]
    3054 |                         devlink_compat_running_version(state->devlink,
         |                                                        ~~~~~^~~~~~~~~
         |                                                             |
         |                                                             struct devlink *
   In file included from net/ethtool/ioctl.c:28:
   include/net/devlink.h:1752:51: note: expected 'struct net_device *' but argument is of type 'struct devlink *'
    1752 | devlink_compat_running_version(struct net_device *dev, char *buf, size_t len)
         |                                ~~~~~~~~~~~~~~~~~~~^~~
   cc1: some warnings being treated as errors


vim +/devlink_compat_flash_update +3049 net/ethtool/ioctl.c

  3016	
  3017	int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
  3018	{
  3019		struct ethtool_devlink_compat *state;
  3020		u32 ethcmd;
  3021		int rc;
  3022	
  3023		if (copy_from_user(&ethcmd, useraddr, sizeof(ethcmd)))
  3024			return -EFAULT;
  3025	
  3026		state = kzalloc(sizeof(*state), GFP_KERNEL);
  3027		if (!state)
  3028			return -ENOMEM;
  3029	
  3030		switch (ethcmd) {
  3031		case ETHTOOL_FLASHDEV:
  3032			if (copy_from_user(&state->efl, useraddr, sizeof(state->efl))) {
  3033				rc = -EFAULT;
  3034				goto exit_free;
  3035			}
  3036			state->efl.data[ETHTOOL_FLASH_MAX_FILENAME - 1] = 0;
  3037			break;
  3038		}
  3039	
  3040		rtnl_lock();
  3041		rc = __dev_ethtool(net, ifr, useraddr, ethcmd, state);
  3042		rtnl_unlock();
  3043		if (rc)
  3044			goto exit_free;
  3045	
  3046		switch (ethcmd) {
  3047		case ETHTOOL_FLASHDEV:
  3048			if (state->devlink)
> 3049				rc = devlink_compat_flash_update(state->devlink,
  3050								 state->efl.data);
  3051			break;
  3052		case ETHTOOL_GDRVINFO:
  3053			if (state->devlink)
> 3054				devlink_compat_running_version(state->devlink,
  3055							       state->info.fw_version,
  3056							       sizeof(state->info.fw_version));
  3057			if (copy_to_user(useraddr, &state->info, sizeof(state->info))) {
  3058				rc = -EFAULT;
  3059				goto exit_free;
  3060			}
  3061			break;
  3062		}
  3063	
  3064	exit_free:
  3065		if (state->devlink)
  3066			devlink_put(state->devlink);
  3067		kfree(state);
  3068		return rc;
  3069	}
  3070	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--GvXjxJ+pjyke8COw
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICBQBfWEAAy5jb25maWcAnDxJc9s4s/f5FarMZabqy4wkx1u98gEEQQlP3AyQkuwLS7GV
jGocKyXJs/z71w1wAUhAzvdycCR0AwQavXdTP//084i8nfbfNqfd0+bl5d/R1+3r9rA5bZ9H
X3Yv2/8ZhdkozYoRC3nxGyDHu9e3f37fba4+jS5/m1z+Nv54eLoeLbaH1+3LiO5fv+y+vsH0
3f71p59/olka8VlFabVkQvIsrQq2Lu4+4PSPL7jSx69PT6NfZpT+OppMfpv+Nv5gTOKyAsjd
v83QrFvobjIZT8fjFjkm6ayFtcNEqjXSslsDhhq06cV1t0IcImoQhR0qDLlRDcDY2O4c1iYy
qWZZkXWrGACexjxlA1CaVbnIIh6zKkorUhSiQ+HivlplYgEjQM+fRzN1Oy+j4/b09r2jME95
UbF0WREB++MJL+4upoDePChLcly+YLIY7Y6j1/0JV+gQVkyITJig5qwZJXFz2A8fXMMVKc3z
BiUH+kgSFwZ+yCJSxoXap2N4nskiJQm7+/DL6/51+2uLIFck75aWD3LJczoYwP9pEXfjeSb5
ukruS1Yy92g3paMBKei8UlAHIajIpKwSlmTiAe+I0Lk5uZQs5oGTtqQE0XGsOCdLBvcFz1QY
uCESx81Fw8WPjm+fj/8eT9tv3UXPWMoEp4ovYjYj9MEQDwMGDBUwN0jOs9UQkrM05KliOJv7
wiwhPHWNVXPOBB7AsYdEcnupHsC5rIJlSVIqym5fn0f7Lz1CtGKMdKPAhguZlYKyKiQFGT6t
4Amrlh1pG/ZVlFNQAX/pwmDfPGquAD5aV9DeKACqek37xust2xNb9hOMJXkB4q50QLtaM77M
4jItiHhwclGNZcL0lvLy92Jz/HN02n3bjjawgeNpczqONk9P+7fX0+71a8c8eNIKJlSE0gye
BfdtbmTJRdEDVykp+JI5dxTIENmMMpALmOFWLAWRC1mQQroPJbmTgD9wqFYuYb9cZjHsM0ub
mxO0HMmh8BRAwwpg5qHha8XWORMuEZUa2ZxuD+FsOF4co4pNstSGpIyBJmQzGsRcFiZT2xts
ZWChPxhSsWivP6PmtvlizkgICtips1ELA4vOeVTcTcfmOJIrIWsDPpl2DMrTYgGqO2K9NSYX
ltIqUzhzAPZE0jmcUIlhQ3r59Mf2+e1lexh92W5Ob4ftUQ3X53ZAe8YQtjCZ3hg2ciayMpfm
2UEJ05mbJeNFPcEJ1iC963MIOQ/d/FrDRZiQc/AIGOWRiXMo83LGijhwGZocbEkhDbMFV49b
qiEmJerFQrbk1C2kNQZM9YpojZJwSc/BQxaUM8d+0W7LnIAa6LZcFuDVGN/RRqeyZy8FDDnW
w5Oac1NW9ObC9dFFngGnVAIcmky4j66ZE50TP0eAFo8kHA20KyWFhysEi8mDY6fIbUB65dQI
w29U30kCC2vbZDg8Iqxmj9xwaWAggIGpNRI/JsQaWD/24Fnv+yfr+6MsQpNgQZaBYlefXQxH
qywHU8gfwf/MBHgCAv5LSEotM9VHk/DBpTJ7rpj+ru11mZKYz1J0eFdEpObqXhWcgH/IkVus
JZG2faMezUkaxgN/Txl5S5xQy5n+qqFvWRwBoYSxSEAknLe0HlRCFNP7CmxrrJJnJr6EM5PY
jCzUnswBtmRpYQ7IOWg5I2rhxo3zrCqFtt0NOFxyyRqSGIeFRQIiBDfJt0CUh0QORypNT0tI
lYMehY6bWdAkt64wCVgY2jKkdH8dHObbw5f94dvm9Wk7Yn9tX8GeE7AKFC369mCZiR+c0exk
mWgCVsptsW5bxmWgVZdhUiAaIkUVqKiqUwUxcaljXMBcjgRAVDFjTezSX0IpfzT3lQB2zBK3
2rEQ50SE4K+6lY+cl1EEpjYn8Ey4Hwi8Cmekpk6K5j0nouDEukgdXgLLOL0tO6Zs5WSmbXwM
pAWWutB3mR/2T9vjcX8Ynf79rl0zw843DEquDIV09SnghcGSieE/gR9BF6AswYGXZZ5nwkBs
fHhgaR4I0M5AclDEHYLyRcAiosUGa6I8V8EMzRkmplBGxhdtGzKIk+EawIBVypyYUoJnAIVF
ibYiDeENmVMaTTIJlGoRDTDGdArJctsKkvIycek5uuBpzB4sbNyDunhUttWnhTvA7KHd/Bja
5Grh4vce1hU81NzS/LGajMeuaPaxml6Oe6gXNmpvFfcyd7CMtZl4Uini1r7ode9Ecsarcuk7
yRzcvYC0UaUJog/guJrpGLBqwIfoHT/CeAZCKe4m1y3LJIbZThW7ybtP49urdutZkcelcuAs
paAYSCZu5wsYF5kwkOBVsiRbukyq4jTJYkaLJgGRZCALPV6MIAYCcMVSlNseEDw0IdkPgDu1
1hy1NJ2RFB4sm6hgbEmiWgjhGIqDQS9YKrkZEoGw4HlRTnFRhVvxsCfQ+oQxRpXqYb2dKm94
gTZa5xLtO00oATpSoKN46IFyUCNplA3kK6EVEwKctv9lHgdZobF+qNrjMpLEVRqtXHaSrZmR
s6KCyHkVlrXxrHXwOb2qFe/+b4iawBZuvm6/gSlUKITmfLT/jtnWo5mgyF0aRl+01rIYsZse
S+8bYiZ8Ni/qmwVolYfUxkd3owCOybMVaF8M8pEzWi3e5b8QV5ngmScm0qvlVFTK5PhxGNUL
Ra7AQWGQ/iYDUhQWM+jRsiiANb/11i94+lCfR2P4HhMRnGwdMDOzSGoIGR2M/H2VS9kD1XkT
cKOpIpwXzC2P1gb2dmDrH+tYc9Ay4BH0jzsI6WxwTuFW4szllevzZWlBeKqspj2zF1+boFqd
9PAT4ha95jnwOfKkkBKOgYlgM25fVyda70pOa4NlDpL6zc60bw5Pf+xO2yeUxY/P2++wKi7S
SZ0l13bwoES/NwYOSxVZ8exCJWtdLK2kT/lPlYqc0BOhePk9nVmv0B8VrHAClHwrr2ueZQbX
Nh4XmDrFeMA44E+FPcWAKT0Qd1GCOcpS7cKdQfG5TnptPd2FpHcqE7R1daWhbwsUSppwnbKC
cGRN54afHxdZk2w113SkOd/HQNr0DVUWNsaTUR5xQ/MAqAQLpiwehpSYQejNZmu41Ja+VqUG
YpOLKd45homDaGoG1u3j581x+zz6U4dJ3w/7L7sXnentnPpzaH3P/x0eb1ML4H9gsGsylIqP
ZYKR47h3fCtnp4ZqFyvOiEs/1DhlinDvZA12T3fwyYCB+qtKQdtCVj+f38N0pk9qIF6c0E6L
nd7vwzH/c+4pLeL68YfQMNlzDhFFa4XZPanz+XW2ruKJcgTcJ1JqA1ymYn734ffj593r79/2
z8BAn7dtKiuILYvXJMMCORvkwg0YhHJWZqpNoRVsJnjhrn00WOiWu8+KGKvAbUMQJjHaAw/Q
i6BLs+AcU/GQFz1Toh2wzeG0Q3kYFeChGYpfxduF4p9wiVmz0LZvmUg7HLeV4+t3MDIZvbcG
+GvkPZyCCP4OTkKoG6O1kWEmOwzrMmVYhVwuYhIwjyDxFI4qy+D8HrCcIzhIwM3VO7stYb0V
BP3vPDcOk7OHwhjSeSSIhMS7lyPL9y54QcD/OrsDFnl2gCXuq5t31qdJqNjXg9U4Qj0ONsUz
uUd3zxZZGMNKhzkIIg9+ZgyRsZE0b0o/POvqO4Z8wDI801FwCNbOboEwgIuHwHYlG0AQ3TvP
Yz+v0/jppPOMa7mWOU+V5YD92xVuDVeuiIafgznnrkBvMd9kE1jPVrRi/2yf3k6bzy9b1WYz
UnnOk0G1AILVpEDvwcpO276kCoMxlGw7KdDbqCuDxr3ptSQVPC8Gw1j46QiGS/aDU99m1UmS
7bf94d9R0vnXA9fYnbto77lJXCQkLW0V3cxvsxMaxXCmG4hjCFMQAj64QEv4k5B8kAwZYPQ8
To3fnKSOuCxrb0F8UfhgGZ37MfcRg/+XF4ptdKbJyl7TvppQGTvB0KT30ryt6p2Jpkbe+KG6
Bmlk+5agdm2C5PMHCXYthNC8n8hVXjK42EFpRzPSlXxo+FNRHcyAWlOnzzotFjOi86hOJRcJ
iDexIcijAt0l2cc8y9xG4VF5rZm76An7ZUJg4k5HMYpGWNhzJ4HCJkOPUdXCfQPovVSgTy+m
1sXphNigR0L7+mWue7Zet9vn4+i0H/2x+Ws7UnE7BJEgnyiUz4Cr0MPNaTMiT5hIGiX7191p
f2iiguZYJPEYB9/cBu4X8zY1qGrT6mnp9vT3/vAnLDBUBsC8C7uKrUfAhBMX2dDEGzlE5UBQ
szQW6cEsszxLNdZfsmtLid3ZhHUkElX2ckKxFL1gbh9VJtSxea6J0nzLdTmTEmkRAMYb17ES
GURY7scDWp66uR93xnNPYKGBMzQVLCnXvrUT9WhnSTcFrZMtuB3S6WWXhTsvitAoK90PQyCZ
+2EQoviBPEcV6CG2unLTCsNQQfNm2F6pDHM/iygMQVbvYCAU6ApqInMzBj4dPs7aK3bsvMWh
ZWDmERqt2cDvPjy9fd49fbBXT8LLXmhqXOvyyu2J5zDTd3HYcApGG1SqWLg6PhiaphybbiGo
jB56TKFmg91Q6QvQa0k+KDx2yBGPfewe5GeAwK8h9ZyAY4tP4YYJT2dPAVzliZncJdx46nlC
IHg4c1swxS/SbaeWMUmrm/F0cu8Eh4zCbPdOYjr1hXvxwglZTy/dS5HcXTvM55nv8Zwxhvu+
/OQ9s7/hKqSuGmSYSuzsybDD2ExaB3AZRIXZ7iA5Z+lSrnhB3aplKTM0NG4GgH2Cw77wS3uS
e2yGblByP3Iu/ZZE7zRk7sMgRnwBDq8sVLDlxroXhf8BKbVrVs1dor+B6RTBIpoa5knkRswg
ItXVaVYZkXyVWOsWadhZnlup07XdpVe3jSllISBUczptHY5WJi7lqPQwdixKrM2YjTXBvfFF
GRxMden2d9sTGZ22x1PPF1I7WxQz5naIBjN7ANO5MS6cJIKEvuMSd/juSVyBZyPWwqeXImzA
cXNqT/nVwysuWKxrB92OohnK7mTgebaA1vP8vG3cTYz/RgmhCsGI8+sR9GWxlXOuSukYV9yN
DQUcLbgnzYoXcuvx7gmP3ACWzytf530auWmXSzBKnjqj8jAiNyxeFWWaMleIqgQagm/01i0K
R4THWI525XyKeQHBSaN6GpYNt3/tnsDJP+z+svIoqmxgJWl0Qtwa6n+p++ylPdj1znU0oVxF
jyBmTp3BGZF5Yi2jRlx9UC1MlVIl8TSQ22hYOv4h5K490YsI7okrCMWjJ7JHIN8LCQ1M91YA
tQIIU3p0vC+5WMje0c+UVRXti9Jl8xBEisFaPHMrfoSBWvXDiFuZIkzlSY00QF03tljHGGya
Azod14NVPHArIhORwp93keTc1nY68Q4Tn/avp8P+BRvHn1u5qKXluPv6utoctgqR7uGDfPv+
fX84WR0RyBXhqspjol838lIOfFZfiHzmUToVtv8Me9u9IHg73EoTSfux9I43z1vseFTg7uDH
0XG41vu4bfLXTcWWwuz1+ft+99onWsXSUPXGuTPK5sR2qePfu9PTH+47s0VhVTtBBaPe9f2r
GVZgHVc9xWU8iBLhaewmOe/Z6q70v3uqVfAoGzbYlLrfdM7i3BOggINVJLmzUQXsYxoSu/cs
F3rFiItEFTTUa3SNSYh2h29/I9+97OHCD51NiFaqmGo2LmLWk7TrYO95Z4sabN1+f2b3HWZT
Z3TeT39fbU5G1RzRx7TSyS1pMH0VCr700k4hsKVg7jvVCGhr62UczXNdaIdoRD6ktEFW1U1X
3JEQUEEE035BGUV2NQKBEQOrozsnnPTwMI5+m+ztOHpWpt3ipGTOh6zbvEdmTOnSv+CBUKtT
QrXEKfaRA4YJbW1JRDKS6qUjfFcXBUp1wxhZPY6t1V82qFMO+9P+af9i6pv/13yrxkVDI6ce
JpyHNpG5bu933g7AwIVGR3OOtZU0S9WajXG28juSol0PIudrXfAEK1moBsBVRa8wcvuSsyyb
YQ9CLVcDnQEbGf3C/jltX487LJS0N9AS5FfDGBgUWRJhWX0cwxc2WvlLC+HJYCOq95VeBIZc
qkKD8kr6CfKmuPNfbNxenZayyJJKyrCo0MWNycMwhV1svx42oy/Nolp3myzlQRiomHCg9Wdp
Xy01MuXpiMgiBzP0mx1zVf/uNzHWQy6PKrWUG3yt1RM4EpLM2JAkjWCYSfE0t1sw65YHV69E
WsYxfnHshYYiS6yMST0H3R+4J6AMzy+m67VjboMaZ1nelQPNUVW3UQ1Rdzd9uGqbyOq5g8eH
InA5o+2JgtA1S65vzkwSJBmQCwfrHU6uXDAVjfaqTkgzTATQcOlmG2xnRv7GgM0dvzdPCPzd
KQoubcrrDMUyYS6PtSXOMvFEqgDwv4qooJ74V8EG+d8mvWHuR7u1u+OTy3SR8HJ6ua7AP3Rr
ILD7yQPGVp6UIkkLz/sxBY8S5Tq4M45U3l5M5afxxK34UhpnshT4bohYcurxIeZ5BZG5+8Lz
UN7ejKfEk/HjMp7ejscXZ4BT94sPkqUyE7IqAOny8jxOMJ9cX59HURu9HbtLOvOEXl1culPD
oZxc3bhBEuTEPWdVrVVrPyoTb/jUxAt+w7TGN5HWlQyjvtffSOS0r2q1hWXg6CRWFNTcuIKA
nE7dOegart/6P4eRkPXVzbU7N16j3F7QtbukUiNwsIY3t/OcSfe11GiMTcbjT04J7B3UIExw
PRkP5KI2s/9sjmCyj6fD2zf1ptzxD7Caz6PTYfN6xHVGL7tXMK8gy7vv+NG2wf/17CEzxlxe
VHzqSVdiJYdg6JO7fZkZS1f3brZidO6W04Am1dJd4cCmFngoxfdZPYkHhSIKuf4BjFK6vcI5
CUhKKuKej+9ceyRlmZOUu4NeS93qd+oxka9HDPZvyI+ObpJZbrQgPFQ/JOMMP3FCv0UTB+1v
ldX6pUa6RKU5qsKPqA091GbrXeqXWX4BtvnzP6PT5vv2PyMafgTm/tVodGqsvdFnTudCjxVD
T0Qa7z20eLMhXiCtgm+L6ikO1VTBXzZIPSUihRJns5mvnqkQVIiiws2BkCrSFI1IHXt3KPH1
FbyzHn0j2g7bT9IxztlrlvjLQ87JCIl5AP+dOYrIh8t3v+XQO81PNplW6sXRYUzmqztrqHpV
fRAB9m5pPQsuNP55pE/vIQXpenoGJ2DTM8Cazy7ALMI/JXP+J81zT91XQWGN2/XabS8ahLM3
Rbw5Lg0m9Pz2CKfXZzeACLfvINx+OoeQLM+eIFmWyZmbCvMCbIvbDOjnY3eFfDhHI0ETTzlW
wRnsb+qGJ+A5KJ2astWgXtjHOeNmtDjnSZEXF+8hTN9B4BfJmaPKhIgivz9D7zKSc3qWnwue
eX5TQ0lWKUFT9i2ctccH4bapDdR9PtBZnqhGn2xgVW2Ttr6Y3E7OnCuqf9rK5xJoxZufoT02
CXrqvw2cTDzvResjFMwVn2vYQ3J5QW9A3Ux7VqKDYKISuyuZfuMD223vJj7cpsGIzKQRMvew
sI6rMK4++TASng3tU+78nQIE3SvmqCbTm/Fg2n1MfIFrC39Hr4f04vbynzOqAPd9e+2OFhTG
Krye3J7RZv4an/aJkncUbp7cjD3xq5af6DwR6JzFkmeAk/l+/QZ32fN1TMvd8yfbdJj5M2oY
7aXaJwr/j7FraXIbR9J/pY4zh94WKYmiDnuASEqCiyBZBPSoujBq7JqxY2psh+3e3f73iwT4
AEgk0B1ht4X8CIAgHpmJfBAzxA0HClyjGVpoKIL4MNWJ2zVci/ZQgyccxBi0SeoG2y6y9WCq
oUbdH2iJz7jj+t8vvz7Ll/v6Gz8eH76+/vryP28PXwalpSkfqkrIGVvSA1VdDsLdMg6TizeL
khiZGLr7cqACjXFa2pKq8fryXUZOWr7Wx/n7fvzj569v/3lQah/Xuza5ZBcxpZBq/YnPAojM
OnfHunZgWiTQnZMl7h4q2MTbqg9IlQ2v3RBz32wrWuWhgXBMOTLr++H1EZG9WxGvN5x4KT2f
9EqJa6/TJCG34mIYuCY4cNO3VBMKaVYTmXuP0cRWIEe0Jgv5Vbz0Jk12rqNIkTOWJ5u7rSOH
4mfHdaEJkCeOe/YpquQr1olbvzLSd+7lN9LvsZtDmwBuzZ2iU5HGUYju6cAHRrMWcdNSAMl6
SbnIPUMVQErZmR9Aqw9k7dbeaQBPd5vIrcZSgLrMYUl6AJK9wzYRBZDbTLyKfV8CNiLZDg4A
OzmMYdeAHDHfUksVkeM1sZBj3IIhsqd6uU0kqZsPa3w7hT7oan6mB88AiZYey8IzPrMdwybe
aHWoq2UorYbWv337+v7nfANZ7Bpqda5QNlbPRP8c0LPIM0AwSTxf72Ue4seyrfjn6/v7P14/
/vvh94f3t3+9fvzTaSQyMATIidQHLFhsQksRbBDA8uWdEcsn5RGT4hutCtJaRcDKrRYlkXln
NZS5h6unbraJs0/aK0R5W9tVKuYc8YleOErNXitnyoZEUIcjdm5dEuYMDe6oKjlK3t4B791B
GanIqWghJPTc8cl8BGKGtrRxuj9Isro/nIZYlvCKNPxci1nT4gzSWVtfKbjsexrEHckkUbll
ehHFATE9kaTWvXKhUbDqcb8ho4r9td8GwqyCLY5yyccqnUsSE+WlaGtr0JwTySyX0hPWzIRB
Lm4szPmvgGiNjlQ+D6ppES947dr0CqMeS4J5aEmqPBSwGAMw43DXgf5TqWmDzgt/EANB2hPY
uc9ub3rq8WLHytK/QSe8KDsa3roDjPAFTBlfn6ToH6dTJ3paJtyzoCc7dNzawbsoiodovd88
/O345cfbTf75u+s+7kjbAqzN3W30RClY8tlIDX7dvmYMg2sd9taMdknpNDRVP9iWCUWtgpy7
FhPcVZuLBrp4umBa1eLpIvlyLMavckVArt7BH61AblgZycANyEmjDUq63jEKnI9Y9G7SFpfc
zf6fENcm2T9euNwcgWWtK16bnsOyzPbWUP4WtQqVrUyaStu+Tlzc7yDLu6v6mCoCP2K2f8Vs
M6py4fE6MBDt3KVq+LgQL8ty3ITm5a6T1223zmpmdvtatwJh88Rzc66d0R6M+khOGlFYLExf
BJel7ZE6twuzAnn4WpO8ENE6colt5kMlydQRaEWn5CXNau66TLIeFYXtey6PLkzr2l/7Ch56
CUZe7EqLiowfIvSsHXCF5WkURaixTgNf3ZaeHHXK9V0Jakcqe0Jid5jPtZlz1hBuOjGbBHjF
2rqeI6LE/PlKt8YQCEjUPEnBvkxgihzamuSzyX7YuFWmh4zBVoPE36nu7vfJZrNmWDb0VFfr
abT07+58Y7NwM7JeRBGnAhPOjUjMBwNTSr57RnL76KhcCh7jGXigygrnV87IlV6skRTnSwXm
nRWk3nC7NpmQaxhyOCG7kIFpEYzuHzj1OsklfbrMDeUXxFkfHYOgVdb2pbzWYgv3vB7Jbn3M
SHZPyokc7BnlWW1vPs6ZaT6iAm1Y+0Me3KnyYrY7iEtJZ6bxcbTauFamhhoMiiro2M0tgvdU
hnw0TZYSlvvpvNjc3eqjXjHRpRu3pJuzfbRyL3fZ5DZOArtO3huYTBWWsdvCh8tpPXcCW9ZX
SGGksLSUhyIOfqjiJTubUfoNkrYDd5LOF3IrqJNE03h7d58AIDUYXBKYhU1MLPyybshUgeud
6ckIUy5/LPdLWYhsI/R+QkJGSwJigwkUrLrNCnlIErBnEPH3yKKV+/vTU2CJKkUsr4+WHfcH
FpgwJbWC+5v1acWtWRu7Mmxb5I9IEAD++BxgPphshVS1NWtZed90mOVBed/i1rKSym9esjNq
8WwgbUueR56m20g+6xYjH/lLmm4WdnXIJ+qX2nSgkGq3WQf2Cf1xC+Zebuy5tTwW4Xe0Qj7I
sSBlFWiuIqJvbBIsdJFb6ODpOo1d8c3NOgvJG8+jvcXIdLreT4GJK//Z1lXNLK6lOro8wc2n
7HeinWynV+kx8Eebc3XLGtL13tqhqiJ+DH/56ip5Buv4VFfB+YxrXz5YP1o9lvg6sA/04YWK
6kQrO4LNmShXIueAPxfgw3akAYa/KSoOeR6sjbYOsg/a/sF86Kkka8wC66mcs8qmPuFeVB1G
fnLqW82OXMBIllm86VMG9slyaJxVtiw4JdrcerU2WW0Ca6EtQFK0Dv40Wu8RU0Egidq9UNo0
SvahxqrC0piZNAgR0jpJnDDJc1hGpRxOwbmk6XiyKJ7cVUKgy6P8Yy1ajhl+HDPwdctCQiin
cgu1zWr28WodhZ6yjUQp32NWSpRH+8AH5Yxbc6BoaIZaPUnsPkIuVRVxE9pLeZ3JVWflAzCp
Qh0X1usJBpFOw5/uUtk7RtM8swIJJAvTo3Cr9jKIblIhpwW9BDrxXNWNFGotvviWdffyNFul
y2dFcb4Ia8vUJYGn7CfAfV8yERDUiSMhVsVMB7ms82rv9/Jn14Ifp/u8o2A3VMrPKlz3eEa1
N/pS2fHkdEl322ITbgSsnTlIjMq1r4pZee+9AtsjsIrO+nsMuVN8G+0xZSm/B4Y55jkSM4E2
iOSm4pAckOQq8vvp+MvDfL01Zu7OI70XeaeLtOMXpQ/y52Aq5rigJUw94NYw5XBThxF7BRsO
uKfpbp8cUMCgn8IBGdtuIrgExwFg9Oyjp5s0jbyAnaeCjGYkx1+x1yGg9Jxcqe8FadaUF46S
y7vAHwWhs7vfyDP+OJhEi2gVRRmK6UWiIF3y3kFMmt5j+Z8Hd9dX890JhRSSp5RsRCd5WBSj
hBkvWUkkfwEh8Jkxiic4ohaS4ZWcF4qoVLhWgve1ujddttl24gORpyc+DQEXwjx5O9uzZx66
4qhwuuSqvIMKpzxOFEW0QizV4HpB7nk0wxvPGxDG8IkFdJGlEf41VQ2b1E9PdgH6HqX3FoIo
vT8rTnI/jlv427G3gyKiTwRqXIhCoY7PO+zxN5V1CQiG2S0E8bGLhuraWRoHVSEVB4IYXmhA
BvYeFDvWFIZdMZ86TeZZBve5yEUpQHrFtgnQpxaoZNgf77++fH9/+z8j+EWTcc9RJqndHSBW
g2MgmsWjxpMN4ghR2gFZVWvnbz9//fbzy6e3B3j/wU8OUG9vn/rYakAZws+RT6/ff739WPr9
SZAOKKlimnBTNQykjAj36APxkdyw6zEgN8WJcCScDtBbUaYR4r080REtsKSDhidFZF2gyz/Y
ZRKQaXN28+03LfcYv6ZbVqbFSxdNWJegYLfiSYwkzltMvWFXykytrkkyLtYc1OEuwkGaaYrn
pFbKfZasUoO3baCfk1LTRezPU4RqKO8c5JbYvqIWbRT3XUTTE9UkmN4GZrlA8C/PuSnlmyTF
fRaVfYFzsyUYtVzB+OQdYmJLorlb3G5zk4t+p7AeMFj5ywcq+KVDrIeUxYgjUuDEsPF82Tn6
9fsfv1DHYFo1FzP4NPzsjkeIOj8PA6lpOvj9I0MirGsQI5ARYw5S3bn8fPvxDuGARscEa4Pt
n68vvMDCmWrIh/rZDyiuIfps+RqjhUVX1E8+Fs+HWnu6TNrsvkxuIs12m6bOhmcglwZqgojH
g7uFJ8lvI/uqhUHCQhiYOEoCmLwPd9smqfuqb0SWj49IYJMRIjKSbCK33b4JSjdRYPxKlq7X
7vveESNFgd16uw+A5kf5AtC0Uey+eB4xVXETWE6XAQNhh+F6JdAcF/WN3BCbxwl1qYKDfReP
znA6xgIzGLlapd3ksaOoI6UZ8ncqPzznrmJQWsv/N42LyJ8r0gAj7iVKTt/iRydI7zjiIqmk
CiqqiMWLjvSihN0cMd00OlHAAUoRpnRqrb5k50fq0nFPoGOdwRGm7KeWDbFZTgxN4kVLEc2h
BpCmKQvVvAcEag3MdVEjsmfSuO1uNR2GCw3UoSFXfr/fia+S6Yv6a5pwGL8/bvpcwpC7XgVR
yUGRIOQaAEPHpXyPXJT2C0RyWG4pldGNO7rK+fXHJx0T7ff6YR67AS7xDFlqGU5shlA/O5qu
NlYiEF0s/0btljRC8p5yjjkmpyaX9KAX++yxliCubYra2+nNKp63zGMw7fZV02ZoHRcFcfT7
RJiKPGxKMENZV3F5mjrrGyGley2M9IJdotWje6MfQUeWzt1xe4bO9e1HS2UXA6Z5ns+vP14/
guA2Bc4aVBbC0LleDQ4t0ya0sN1VvFTaH24iB8BUdr4ZZZM6QRgEyPKE2DxDipR92jXi2WhG
u86ghX10tXg7+oqXuQq1c4Hob2SMWMrffnx5fTfkbGOekLIrSFs+Z1YAGk1IdRLxZaGRb0w5
HlljY+J0PD4HIUq22xXROY4qO9KyCTuCLOUKrmeCFl/C6oEZSNkkFHfSuilV211IKzuVuKgt
5CBlRQ/ZuKuW4kxuJqA3qSqoaZ9+zPnSeSEgQxcWq83qDBbIxKwO32vGakScpo5oeN++/gZ0
WaImkNKOOFwM+qpgRObXMDZinnx3LHStnJ78gSMu4JrMs6xC1JEjIkoo32HhUDSo33M/CAJ+
Bvi2OkGDsBa5ONbktsF3d0k+8rIrm1AbCkUr8G1cQof4Avbinw2+HVDAYBfuRKs4SsQGRiFU
6BLM5uq5ypRUc3K/QtWd8xKxo+hOyEev6pcaM/OBSJwC8ffp31aFokJ0aZBBTZ6a/UR0sywN
o5KRqPISUQzInb4FAxR354GjhDskx/qQHbPy5snffdDToeammP3q7Ix4Y5ErB4Ds8yk7F9mj
SgPk7rvI5J/G3fM7LctnbOAUEeMn9XDIU/TChRFJ1zlTl8e0VhVIlnapT4nnueVlyZh63FC0
yFIlqMlVUtvFOruzpXmBUrk7owoNSZ/l7DIoOoK3Onzthkh5qg9TFhR4n5GPgajS08v1mvEH
KbPI8s/ffv4KBG7X1dNou3arDUZ6gsTHHOiIF76is3y3dWsTejK4ePjoUrp3b3ZApwtezyRi
nuVABI9pN7sJ1ErZsOHtaqO37tQgadEkhFPJ8O7xkZX0ZO3W7PTkfeI+dYCM+Zz3tKZdxsJX
3tfINOCZvTFOa0eHCP8HxC/Xjz787T9yar3/+fD2n3+8fYKLjt971G/yxP/4+cv3v89rzwtO
T5UKho+5sasFiOte1BfLiD+uix42tkhBYJD1/dviTSFo9o+v8qCTmN/1+nntb2uQActpDbL3
BZGY1WbQxAkSugHIbX2oxfHy8tLVHEmJAzBBat7JDR4H0Op5LpGr3ta/Psv+T29kfMP52+jj
y7mvohvObNxnuVBsYonlgtGzA1zQ8RjBIwS2wgAEi79vHgPGc2uEy0JMcniDsA9nd3ouO42W
/Om5jqpEA4jFV4Syj+9fdChXRzYUWanklMDA9xE/ng2UEvJCoFPjyKUBPfkXxHx4/fXtx/Lg
EY3s57eP/14et5BhMNqmKfjUm4mV7fJeFlQ5gfWiVDmqHrSpk0pOgKYk/PVNdvPtQU54uW4/
qczYcjGr7vz8L2u47CZpLtK4QZTUS+w8S9dwpbx4daMSWmWiRQLlylHGEl7d3Meazq8kd0mn
4e6YfakprVSOZjkaIMICLVxOGrB+AoSb/YPEHDgZ2CIILAE3KqvE/WYHIqRk9Nxlt3iF7JoD
JOfxDgn3YkH8DSmI+4QfIByJHDG8D0Yfnj88xWgszgHDyD3arRAfrBkIcb7seyNB6R4JZT5g
yibdxTs/RGSbKIndU3YAyTfbSL7P2+kTuZwKqC7eb/yf4lSX+ZEiiRcHUCu2K2Sljr3K9/v9
1hX0bDGfVcFw9Jwd1h2VjkLnODDHkO35bhMhgQdNiFvpOUFYtEIur2yMe1HYGDenbWPct20W
Zh3uT7RzTyMDs4+RaT1hBBqXyMaE+iMxCaYSMTChIPwKExjnswj1+OlCQDy8qHSfW7Bl9+P5
OtQvnu2S0By5Q/qcyptlZqqvKZA0riNE3Bt/g5Jh44S2ks1tER3ODNhwt7A04JT5E3h7+1E8
CWRkgIwIgcGi20cpWiJBa3vMcRelq62bMTcxaXxEwoeOoO16t0ViFfaYU7mNUlRXOWLiVQiz
S1aYUndE+BfKmZ6TCBFMx/ETqX/1f8iQw2oASGahjeLAl1RWwpjz5YBR54t/zWrMDr3ftHD7
QJ/geNz6pxdgYoSJsTCxf5AUJvxumxixELEx/j4Di4FwBiYkWSX+/ihQ5D9jFCbxn4uA2Qf7
s452gakKiUBC24HCrIN9TpLApFaYQC4YhflLLxaYiCxr1iHGQWQJksx7RDQ8XqehudHu5Nbj
5r3GOcYQLeEE2AUBganOAjyHBPgnVckQucEAhDqJ2FgZgFAnQzuMZJxCgFAn99t47f/wCoPw
5TbG/75Nlu7Wgf0HMJvA5lKJrIMIOoziQY0HaCbk7uEfAsDsAvNJYqQc6R/rqlGuRX7My110
jy15LKrAoZcd0+0ekewZdkUyPM0PAouUPiJaLPPCgDiLwJYhEWsk3vqE2AQRWaAVj3J85ONY
IXd3/6wpWBZtAjuTxMRRGJOA4sHfacazzY79NVBgDWvYYR04CbgQfBfgNjhjSeBQJnkWxWme
BmVRvkvjAEaOVBpirysSr/zHKUACy0pC1nHwgMNC/w+AM8sCJ7JgDRboxoL4Z5CC+IdOQrBM
dyYk9Mqs2SJhrQfIlZIkTfxywFVEcUCsvoo0DmgCbul6t1v75R/ApFimDgODZvMwMfFfwPgH
R0H8y0VCyl26xZJHWagEyyA1oZJ4d/bLkRpU2Cjvpd24HOH2eqF57UHqPCWWK0lfNCQAc/Zq
wHBBBAVTTlccwQFUsKI9FRXYlEEv6uNRB4TtGP/v1Ry8UMMNBAjHqvLbQmRhX3NDmpNTDTnF
iqa7UV64ajSBR1A/KMsp7/uaj6i02ngs3+ERvHYH0NtfAIAvXoc65JnIv9g9iJlF5rEOR9SN
iOyc167LAA6+YzXn9DAzq7LvGfvSQ8aIEw6ExZRWDn3//OPrR7im8bjxsWOudGPILtUwmmkf
DUSLAM8rE+sVctAoQL7f7iJ2c9tsqC7cm3h1x22jj+DFkGORpFUvc7JfrfE+AHkbe1tQEPem
NZARtc5Idu+KPRnzAVTkEmFr1atnEQS78Q9PEyeI1lkyil1DOM3cvSubrKOIEQfQMAMPaFU7
xjfMrXxViCeOJYAB8gdSvXQZq7G4YIB5LFiDZEYAcpqq7EABOv5dFT1BssLqmXePNltELO4B
u12CHIkjIN14Ael+5W0h3SOXEyMdYXMnuptzUnSRYPLlQPbVXlTHODowfHZeaQNZjbD40ABp
C+FWXQNRCnVbubrwAWzzbI0lGlF0sUkRNkuT0XsvRc62YosIw0DndLNL7p6ocYBhW4QvVdTH
51ROMnwP4M88Q44YIAvI0rVeb++d4BlBMoEAsGzWe89EhLtLxGevb6Zkns9ESoYk2hMNT6IV
cpsJxO0KSY+i2lWA1H3zNgEQpc/Qc/lunhNCVZEi5mAjYB/5DxEJkpsRMtXErZSC9DInsQmA
6F/+mXQro3i39mNKtt56JrR4YnfPaF7vqecgJC19qSviHYYbSzeePVmS15H/QAPIdhWC7PeI
axf0U2Rx4uIqhszBPh5pqgoC20sGD9GXtZnnQ4BDeJdBbPJLg/opaZQDoRPA/Hj9/vnLx59L
ix9yaqbIp/JHRzfJyi45N93LPZrKridIc2WENOoLVPaDU3MxkxrmrZ31pGVd3nTkcvca4CqY
uvDnRXmcJzU3QI+M9/a481bA/riTY5JD7gN2wwSKvkOZM8I+EIVgRrIPXTA1ORpfvn39+O3T
24+Hbz8ePr+9f5f/AvNKi0mGh7Xl8W61cq+aAcJpGSXuKTlAVHwZyQ7uU/dWs8DN2UbD3A7r
vBZrW2a4U43PmcXm8LSSwZaC4+xr6FIlCzXCvQQARliO2ekCuaov14Lg9CsWCE4R5VxBiZcc
ydACncLSokgaO5FTjOxQQH+64/X2jgizFzYADamK0cQu//Lz+/vrnw/N69e3d+tLzChmDYeW
5ifDE2esdaJYldMhhsDD4ceXT/96W8xfUhHwR77Lf9yX0URmHVrWZldWiIr8P2NX0tw2z6Tv
8ytUOUzN4c28lmTJykzlAHEREXMzQWrJhaXYSqJ6bctl2fV9nl8/aIALQHZTucQR+iF2NBpA
L2tOc4Bl4gT0kDk8ywpR3nmEJAGYVTSeFFPi0AkAweWhwHMJLWWVRYELm4rHUBGv2n5OMtDS
VAf78q7g2a2ouYb/un86jH68//wp15vbtVf0lxBNDF7VLXetS7TD0axUIcv9/T+Px1+/30b/
OQodt++2oj2jOW7phEyIyp8RdnfAnNtQGdmaQHOptwjlznQTEqorLY656WJBnBk6KELzpkVJ
aYV6GjZA69nk6ibENVda2NKVciZ+VjGqlTlbJ8Zdklzo+UbbzVUOjuswq+fToxQeqvWjhYj+
lg3brdO1hVSxdC4ky79hEcXi6+IKp2fJRnydzNpWXKpSjevJF83tVFLERqg30fmh7ZTspNSJ
7IRg43qpnSS8u3b6GekZ20Tc5eachORECLhfw27PdIFVPT7sz9xdzOBSKOJxkmFXnaoqWuSC
sIsls6LoQtZZ4pS+sBPr0LxApGk8zm97FSIUgtWX8syUm150q34qIEBGhnRfFXypkwzdV6po
XziN+kJ2b58kt7j+N1FaXF+NlV2lTUjScAqm9HgqZGhTmPPlRk5dCPBgpdfOuaye6MWaUjmE
iR2s1exPtO55ytbddmqjWGXpjLW0VyhUu1Lh7hhbWJOSd0efuePFgnirAzIdWrYlq8jkhGIa
gIrFgtKZrMiUIlhFpnR8gLwhnu4kbZkviIM7UB12NSZEZkWOOBk6HmbQdrfyMD+56ltxPVmM
7XGTafPtFksD3zSlK9Lu0Dj51qcr4LIsZAP9tlKvsCQ5ZLvBz3X2xONqnT1N1tnT9CiJifdJ
IBLGbUDznCChHhxjuPV1OWEl1JIpo+MG4H67mAM9r+osaIQXizGp89vQMS/fQFUOLrrrP5Dz
h8wPiPTylPvd+GZgqNRF+mJLV7cG0EXcJtlqPBnTKzVMQnrIw+38en5NWAbq+bIlbd0lOY4m
hAmq5onbgNA3gr2fQ/xkQgUV6JFHxG+uqF/okhWVuFfVmwBx46d3ErYgNSha+gXWDMfFIhH0
elhvSSVVSd1FfodHaic77mf2/nA8WQ/Wah5WfgFQ4bb56j86n6TgZDBM4Abju/d1fm3SC7Hs
sk1wLMkKMppLhSjYmNLFqBAO44xwolEh5t2Yfj1EwH3qjVZtUI47uaJ86VdZpAmh8tDSg2FE
nsQe7YqoAilnKvR0EmhsDiV1gIes6vgZcLd/spCJluUNd1sDqzzz4hXhv1QCKVdHRYDG0YWs
20DS2nvNy+EePFjABz0XNoBn193YiSrVcQrafZdGZKgxv6KB969elpDICdcPQC+yTjQCs8O8
8JbHvW708iQtfSwmGpCdwMsyw0ORTuPy166bk5MUK0bXLWKOXIG4dwygy0OHy289IgS8KkBd
JdNk2fZcCtilWF7N0BAjCtU4lrM+ltNklcQZF/hCA4gXiU4/2eTQcwi/G5qMebtSlO+y1d36
rLxoyYnnREX3iashRQyTjCeEKigAgiTseDWyyGu+ZiEZbABerHfDE/t2R3dj4ahoNyR9w8I8
weUQXTdvI4iQOqrtu0xdapnCDaSD833sSKNoeW+lfWNLQhsDqPmGxwEa4UJ3Tyy4ZElJb7GF
Dm3gquhenKzxPUcvIdlxypHeACSEwE8D9J0fMoH5SwZy5umFYC94M3aamZyAn+H+3FURv4cn
SJzTsyvOM44L50CFALuYPy7FQlgMWkty9rvm8BvJQws49eII3JlRmXs5C3fxtjuxUskM4R6N
zBbcUWYwY+n1KDE7kdNaVpo/8ojYXPXIyUIIIVPRE8dh+PYNZME43a91rKNOyyFIwBAbURaC
pIagQpDBryuqF8IthoddcSlEEUPQi27FKA12xR/AHyQTA/uI8in1LdlBzjQH4APrVPIvQRlH
KnoA3oj0tRjNJ0FyKVOBv3JrTjm04Wy5nM4k9buXJYMNBHfZzhAn0dqjZUD47FDiSJh2Cqhd
giESlXYaLZa4AKgFYbe/+PBeruC9Z9yq/G4xrVskq+wmO+VdSQlsXa8epocT89vmQGKWYlQu
CRwO0SXz0JNHdSnWGCwX6NXlrZ0IAULsnU2dQsKUd52WGGTlgjRgogwc18quvUZSRwD7Wk99
GceSHzqevltSl9p93yLR8Xx/eHzcPx9O72fVsacXUDg422NX68Wm4Jhe5N2ifFkCj3mu2Bgn
jukqH/Lm24Il+UoJlIWThxx9pNcnvDwRhWRT6gZb8uCvE5Os+7qdl+ANy2m9Ybl9dVM1SPOb
7dUV9DZZuy0MfgdgkL2K3B1olZ4lSQ6LrsypVilYnsOoCSm+24OuqTDYWOa+wF+FzVoN+09S
nb8tJuOrIB3sAy7S8Xi+HcT4chhlTgNdlbRdhaRi7UyGmmGuKmIQRAixYYZqnS3YfD6Th9oh
ENRAeTyJOpt2M90q1/TO4/6M+lxSE7jrTcZc0JkKA0HSNy79bW7rOmpnFknu/c9IdUGeZGBS
/XB4kVzuPDo9j4Qj+OjH+9toGd4qJ4fCHT3tP2rHPvvH82n041BFNfnfETjaMXMKDo8vKtbJ
0+n1MDo+/zzZ3KPC9cZCJw94RDJRVZiJiziX5cxn+K5m4nwpSVAbsInjwqU0MUyY/D8hn5ko
4boZYRbVhREqbibsWxGlIkguF8tCVri4yGTCknjAYbkJvGVZdDm76qxeygFxLo+HF8tOXM4n
A6FoCtbfwGCt8af9r+PzL0udyNwIXIfSwFZkOB4NzCye0jp0asdwYzGoQqcKUVzDJXy6qq1x
Q2jAV0Q6Ag84r+GuRw8IMOsbWxmi6Tvlk5fgT30f981nttxAfC8PGIRJQkUlnNUo3ugWeYGf
l3TV1sKjmUborZKcPKsrxAB3ryeus7txCKMJDVNGNnS3u/RhX+2POTxwh93YM2YnwIWhK4cv
JEJNKEAZ+eD4ReTaCRLdZ1xKS8v1ip4ohB2D2lMyJmXJNV9mpLKpanOyYVnGBxBdrcuOlCK8
XO+sPt/mxcCy4wJ0ZXzidlgCdvJregJ539UQbOn5CVKa/DuZjbc09wqElGblf6YzwjjUBF3P
r/A3NtX34OtYjrOX9bqoWXXp74/z8V6evML9B+6YMk5SLaM6HqEBVzOEKeEif6AcO5MVc1dE
BId8lxIeOJWEBSpBYsNzynSHMtXwIjqqBBxy5FrBzxTMkWcfwZc8xCPQcvlvzJcstuTFNlUb
20UMXx5dnC5tsBjJ3txMxwYwgzo1ZHiUK92IocQoDxzWisxdipanLG/c4fbagF1qROJkLrG9
A6HMtviqVETBN8Mt52miVHGwkhWtdDChvofqtRJHKHnwUotFRkXJarMUVDCvFpPlWe0/84+g
Mss1arWb5U5pBfeFBKUcaScFjjwB7/DEWo/t0+vb/dUnEyCJuTxH2V9ViZ2v2rHNHVJLDGhx
5X9c8aIMohWaYcMMoDzV+FCY36m1SgfNNSRZ1skcaDO9LLhXdnXw7Fpna5yhwqUP1BThovV3
bLmcffeIO7wW5CXfcZm+hWwXhAlfDXGF5Mi4YqgJIXwdGJD5Db6l1RDwPkQFg68xmZg50wv5
cBGOJ4S7AxtDaA/UoK2E4GedGqGcpkyGR0FhKBNXCzT9E9CfYAiTu6ajr8c54WuohizvphN8
O6sRYjqbfiH8udUYP5pS3tqaAZXzj9C/MyAzwl+qmQth5llDvGh6Rbj5aXJZS8jwvAEIoVPT
QhYLQuRq+s6VK2rRW/fg2tle9yZfAY/zsCOkjfo04MH18B/wC1dMJxfqLWfOhPKyZvXQF+LE
1w7GfDzun+nSx/3bz9Pr0+WqjieEjZ0BmRGW9yZkNjwKwJIWM3k+iTihPmAgbwj3ai1kcm3L
0N355/PuVqGmQn47vsnZ8KyLrhf5hS4BCBEqwYQQ4QwbiIjmkwstXd5dU46pmhmQzhxCgamG
wETqz5HT82cnLS7NED+X/7tCphg8iojD8/n0eimLQa++LvhMwF8lJGlZ+P2nCIgJIw+GtmZN
UaGJMiSpjJK1J49GOfeJmN4aRl9EVoDaapCwHtKgwGPdd7NOLiD9KNcq+PNap/XGMabYDl0G
FIS+29qnCOqUobXakTVVGZJFXlxYEcl0MqUZXX8VUYW6djzDOhkiHPfLUqlU/GhNBeUGUb3C
IaZT1TPX/evpfPr5Ngo+Xg6vn9ejX++H85v1WFjb3V6AtsWvMo8MauMkoO2EkuTArzjh4AVb
MPVnRQaKhM3Dhx3zrCJOKwOAOpANXoEKvEoJtcS6pCyZlssip4Km6vdMeS4hNAQ2cueMwXE+
fppnPFwmmP4cl/kW8t+1efxNmOCu+Rswll2MTmpfXrWBMkQrON6PFHGU7n8d3lRIAdEf+EtQ
4xynSqrfRNWpN8+4g73o9aEh+26p3NiIVJ7x8iBLihU2ByqseS8gf2Q6mKZ5VwB+TxQYTWxK
syIdGXThsFD5YoLnLRutD3iHp9Pb4eX1dI9yfy9Kcg/Ocih7Qz7Wmb48nX+h+aWRWA0FKLG/
NCYyGIltOBIDFHRZ/0vowDbJ88iBkDWjM6g1/JQzoH0a1pbKT4+nXzJZnOzNrrZYRsjaSPL1
tH+4Pz1RH6J0/Vi3Tf/2Xw+H8/1eTsC70yu/ozK5BFXY439HWyqDHs2MvBEe3w6aunw/PoIt
d9NJSFZ//pH66u59/yibT/YPSjdHFyLf9IZ2e3w8Pv+byhOjNmotfzQp2gqk4Exg7WceriLu
bXOH8okiV0iGb+Kc2DbjHL+EXkceGZIu3US97oGokGCFj219PZpRrZQ5t2RBKhpJ7Xe+E9xO
n0qCneSjP3SQKHNtV7raEM8Fb0KwKx25r6urUrjTJm7hlk5U3oLbD7ixH8wt3bJysogjdSt/
GQX5oUzHbpLxNWzADsMvFCPiITQj/NLAo0GvM9nzw+vp+GB2ozyyZklXmarmTxW8RYd8Ga9d
HhHW6QzblGM7wKD62dzjtbNUJWeR1594wWb09rq/h3daLARoToS3UrtS1zyg1s7qZ9l+6afE
Q5cgLbdCTnrgVcoY8v+x5+CyqAqlSwQmrHRBXJP5+UfJKfXksTa7NQu5y3KvlEeElGUCvR+W
NLlRm+EbJbOZWAbBVUK5ZXme9ZPTRIC3BSfsk4TnFBk34xpLyrSb+ZTOZUrmct3N5ZrO5bqT
i8lXr8m76G9L14qXDb9JsCwgWjrMCQzZKfPgpl9S7IndJKswmAQTrCDKOBviRWL3FG323aEx
SUiXmGSsW74pElLktm6M8bs2Ll9fm1kA5a5IiPeSrVkvEkHoQAApicHvhBQuM0LpFEAbluF7
JhDpA/rKF5NO89u9Ic96fdNyLB4OfOpP6C+hPiirpKY09Lg9q+q0clmFP8PGD+47SqDLQ6Pl
tAMOvU62S0m9c4mQ+yX+5OkLfR9inCS6CVwnqEdNq2A2cJXSmz/N3UWe+EIxgCc7TSe1ucvi
qC5PZHPAsazfvzJy9ve/bdUfX6iljXLkCq3h7ucsif52165iyi1PrrtBJF/m8yur5t+SkHuW
Gux3CUOXX+H6dQvrwvEC9c1XIv72Wf63t4V/4xyvkqR1+FMk5Jf4+l83aOPr+kwHbg5S0M27
nt5gdJ6AUomU7r5+Op5Pi8Xsy+fxJ3MqtNAi9/H7VdUWvG5x3ht/lTQUJBGYDK71AbRpb+7U
m/BQz2oh9Xx4fziNfmI93nO4oRJu7YDkKm0dVYmtRNgmV8+r4DUC8w+hkOBLMQ87ucIYgUYz
z5Osl7cT8NDNUFcEt14WW75A7JfXPErteaQSLrB5jVG71wBdcg/Xm2N39UGx8vJwadajSlLN
bFOlGOlXhoFWh+o/1H7n+XzNss6aQ8a2KYULfakMT+Cefa+WyGPHyqP3AOYO0Hya5im+TVED
+kNJArsPcqsbqOtyoDo0yclYRJDEXcFEQBDXWzrPiMdyelE8PhpofUrT7uLt9SB1TlOzoUJT
0FAlbkp3Yk19Vgx0d5ZQk7eOb2rPx5pYM0vj93rS+T21mKlK6a5kk3jdhYsNcXbV8BJ/cAIi
bNz6/l3KEmjjKhAwJXmqc+NO21wu1K1j4aZ9CxoJcK2mutDWD6sK7mBj3Y64q5KU5CVliqTA
BVcFAv34Sxg/lDuLHLU+rhZRM3WpLgWyxGgIFN/9qetpdExlOdRy8SLOUtM7kfpdroS1k1ap
pHMnTd6m8hwAqlvmp46XBvgEdbg5A+GXfsmatLVTieCuAYyC1FGlnhcWEwdUkYJVOc54OLbJ
mMSeBlibSoRJbehqAy5Jc3UN/IP6iU18GRMt5czOqIsDIJOKYJLYDr85PonL6H2H4i2hud5C
UUtulmhnkGvZsJSyof1hQ7mRlCeccjMjKAvTnVWHMiEpdG5UDRZzspz5mKSQNZhPSco1SSFr
PZ+TlC8E5cuU+uYL2aNfplR7vlxT5SxuOu2RJxuYHeWC+GA8IcuXJMtPERCZcDgWK90samzP
tzp5gldsiicTzZjhyXM8+QZP/oInj4mqjIm6jDuVuU34osyQtKLbixFzQGwhjAdqhOOFOXHL
3ULi3CuIAK4NKEtYzi8Vtst4GF4obsW8i5DMI6xxaoQ8QoWUInODiQtObNdm911qVF5kt/iD
PCDgzGuZtcXcSVBHFTwpN3dqs6qdq5oXwPpR8nD//np8++jrvcBGZW508LvMwAcj6D/0bzlq
yVVb68oBhi8yHq8IeVRfI3kuvSNKQukGZSKzVH4OqLhI+l4SArcJ9SzUexfvYQeJ6D4WsLVX
Ki/fsadV7p0k3SmJw2Gd83EPhhcHzhschYEXb+2GGym5vupo28kMfeVQRF8/Pe6fHx5P9//8
Bf88nP71/NfH/mkvf+0fXo7Pf533Pw8yw+PDX6Ag/QuG+68fLz8/6Rlwe3h9PjyOfu9fHw7P
8KzRzgStxnJ4Or1+jI7Px7fj/vH4f3ugGjdVYIIt2+LclnFie/hVpCTWnWS86BOPHRoMJpIE
tpZDHGWbDu4ISpCCoAvBmcXKmq4IGb2iIZpXk+neaV5wuyuoqSfM76RxiPv68fJ2Gt2DtWrj
m7ztRg2WXbWy9Eus5Ek/3WOGHG8k9qHi1uFpYDpP7RD6n8heDtDEPjSLV0jtyJxv0xSBQ/Ty
frLkl3JX79e7SrdeXipSgb9g2R82Jz+lXNcrduWPJwvLEWxFiIsQT8Rqkqq/xCWHQqg/mK16
3StFHkheaQnimoIaGKTvPx6P95//OXyM7tWM+wXejD/MO+p6yAT+5FKRXVyBsqJ6zkX6cPae
k11AiIg4UFX9Vsjjy2Q2s2M+67fq97ffh+e34/3+7fAw8p5VR0BAi38d336P2Pl8uj8qkrt/
2/eWoGO6bK4ngxMhA+AEchdkk6s0CXfjKWFP0CzKFQft58EWe3eE/VzTaQGTfHLda/ESGP/o
6fRgWr7UtVxik8fxsYhqNTHPsE9y9GxeV22JfBISl+YVORmqRIpXfEsowtacxdttMuIyqR4K
UNrMC8zgq26MEHzdOBfcn39TXSuFtd5cCXRir96yOUO1WsvPeuPqHn8dzm/9cjNnOnEQdqMI
Q6VstwEjVKMrxDJkt94Efyu1IAOTQVYjH1+53O9zVbWn9HvnT5ZQ5GIX+w1xhvRHxOWK8UL4
O5RzFrljwm9/vTQDhvnFbamT2by/swZsNp4grZUE3H6hYX3D5FzKSMsEf6uqMJt0Zvu91TvA
8eW3ZX7ScCeBVFOmloTTtWYmJBtS176eDCzy5AltkNc7TOSDYw8A3Eqi3q4IB0AV2b+8D1fM
fJhBZyllZ9kMHW4sV+/Zm6TbX1W4hKeX18P5rEXrfuP8kOX4eavmtN/xw3RFXhCWH83Xg7WW
5GBwAX0XtgijdWvlqeT0NIrfn34cXrWmc3126M20WPDSSTNCQ73uhmy5Utr6Q6BvHHy8eqAV
SBy8DCERlLnLSxyxAdaS8h+BL7SlwYG03p8O+rDwePzxupeHk9fT+9vxGdmAIJQAvnaBgvBp
DKZn/kUUKm/1cTUnl/IluE0eo5n9Cbtvq4ZLWH00wYaDDbIzgBkvyyVnkpLL4NRugZD91fWw
0CzB8hybJdvSiePZjHCUbaAF872t03VNjVQhUi5QyxURhImJXRSBIzRHXZuAM4T+rDq8voFa
sZR9z8p10vn463n/9i5PpPe/D/f/yOOtpR6pngJhFkGMGNHc56DH6D/JW2Ue9ud0e3fElMIR
MspL2akemAwZL/WNlzq5H8ZOuiv9LIlqxSEME3pxh1xrAsceqJLw0LpB+P/Kjmy3cRv4K4t9
aoE2aFLDm5d9kGg5ZiyJNiXZrl+ENDGCIM2BxCn28zuHJJMSR9m+JZwxSfGYi3MoY2eC3ICJ
NRNQ+rI4HMXUeRgr3XeabEG9ZpoovlOqbLVTC36Us8ncP7oKtBMdzOIGsPOpK26peiiCwahl
VZfuDQF5sTfEnxdjheoahFSrJP7rMvBThkjshFAiu5W5GWLEghEVoEIlOYCIgG+BzwByERKi
1WUAl2VmzzEzymcmG1+oPVIknRPjdsx1e7zOaOhoMkp37ZNgOzLWIGC3x+b+//XucjpoI+fw
1RBXR9PJoDGyWaitXMBZHwCKFRzbQWusrj0HT26VCh9231Zf7bVzIRxADICLICTde2FJJ8Bu
L+AboX0SbMflH15d1+jbgMhVexOlNYrmzq0uCqM0pxiPrI3crOgR+VO7/u3cRD6yHm3A9n78
FfptOu9VSTKrCwaklNq+B0MA9ElG5z4JRRinhqmnE7h6AerJP7fLWqWJm3a02GpTpl4pBOoN
5BrRA+Aq5QV0CNOqAhXM/eLZ2vFFu0qNNwL+P3bz8tT3cdZ2jQKH0+NMZ16mE0PJkK+Ax1mn
ilSligsKsiMX2G760Jdx+ipgxXjuHS8csDjfzt4yWmp9fXt4Pj5SrP/d0+Hdtb673CYvl1TW
S+JGCEdjtyCckn2+JF+QuNLprA7WMVBN5TSQNFJgtmn3Vv9NxFhX6JLalcbI4NLgE+ygh8lp
LjFmI22mTBlUgzNuk7aOhEe7GINseZ0Mk8UGWFKdWAvoibtN4tJ3GtnDP4ffjw9PjQjzTqi3
3P4W2iieiuCFP7cwPrmafwcx8tLdHKtXQCowtEUo62lBSSBbNWAFERaAAKII+r6UPccQb25F
oqh8Y6aLLCqVQyb6EJopus97DjTcy9xYOEnbJFricx/e37BM+LNL6EXNNvdkdvj7454yLOrn
9+Pbx9Ph+egoQJTXHkVUu3Z8N0+N3RNSklOc6h8/zkNYnG0w3ENTDK0tO/f969fBOgheeHER
TvSPb4hLBUD0rlnptHFx78UCjy6Av53s1OayLmxF59L22al53uo688VtTIG5K7H2gPAqxx0i
ItHsMPmhNJ7bXKA9BF4ZjRUYBJ2YRzHxdaIE626RVm1uLSnAHDEC+Q1aMKY1bt4pMXezHFLD
o2xC5uFmeSmQkh4sh1ejuQ/IbIMGUn67RHdLWIw6N3AYdAmKMnHgtsiI/zR52rv+YMUCoycH
RmPE/2JeXt9/+5K+3D5+vPK1W9w83/fUrRwOO9x5Ew4C8eAYJFbBPfKByJNMVULzaaXNvETl
pVrBLEvYUSEvIwPrRQXrUEZFeDO2a6BDQI1mgrWTsjbyaEESNL4W7AEBlOnug7JzO5fEOzYD
pz9qlpNphLrs7x2u3DJJVr07wToyvuac7v8v768Pz/jCAx/x9HE8/DjAH4fj7dnZ2a9D9oPS
Y1UmO8Eg2pycQJYE/5BzF8MDbrdFIhWfJgQQjJEtFyl83AhaE1zEhrXRFCcUpgSnCDNzypk8
t1uec1AydDZu/nlXqpjxoNtIlyEJpJXz/sc2DYQEuwbVUPCNOYlr4U9FzkyeDTnWjEDvBlJI
R1Z7ycRVoBWPzHHubo43X5DV3KLdJiDZ9PPi92nfJ/BijPpTeJdOhAT9TPgpryKKerYKBKB5
V174pP6oysL65SXw+WF0l1VVmG8CgLJVjBwhRPn0nCGSTeZCXw4SMhSS6zp6e3HuwumoeAYK
aEzWwZCmNn2F93H9ZQGyyzKeDUh3jta2MOUqrdiXKWlj8SXJZ17lLGLSdK2r3wK0Fefn7cd4
P2XdJaOAZ1gzNM05AUUEVHhlPSIdYT304b4+3EwnIVqP9hB0mM8r2I3zaeYpnQQkrQVmtI+s
kPS19SnZLITXJuqnOXts6fsMrcfiTzk0/M9wdczy8H5EioScTr38e3i7uT+4B3hZ5ZKbYnML
UV8yFmSca1YLgshNtF4Ixxd3QMhRZtPsk2uJsrCdaEnFs4/MoJ+Kicsd6JzyW8kCwExvBLtg
3Om9yBZGrmKMhpsROBlYTGow+ZCI5VmBZDSQEfHyiHDmoHAARlkZffki2fXD+jy9Mr/6iU4a
RPZADJ/rFq9QwqMaISwBoxQSHRACXaBw1jQeQUX5CJhNLTK8qoTaPgTdkQVOhmOg7zw1YY8V
wrBoCKa8RyM7Ir0mElQLFRFYjl2GWXj77UZI8UbwTSZraLw4+OIoeqPyGKuxxcd3oAVafwYl
klp6oLG2KIhMMejLC7QXyr3Ntc1AjhlZSA5JHfke2XjUnFbyrxW9i/nEZkKZU6Y8SaYiOLWj
g6AYK1DTtpNxBPJ4RS05rEyM0vSBmyobF/8DKBgB45VJAQA=

--GvXjxJ+pjyke8COw--

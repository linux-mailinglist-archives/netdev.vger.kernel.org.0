Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46371BC6B7
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 13:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409620AbfIXLYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 07:24:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409606AbfIXLYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 07:24:24 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD0443081D8F;
        Tue, 24 Sep 2019 11:24:23 +0000 (UTC)
Received: from [10.72.12.44] (ovpn-12-44.pek2.redhat.com [10.72.12.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 400985D9D5;
        Tue, 24 Sep 2019 11:23:57 +0000 (UTC)
Subject: Re: [PATCH 2/6] mdev: introduce device specific ops
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, tiwei.bie@intel.com,
        sebott@linux.ibm.com, airlied@linux.ie, heiko.carstens@de.ibm.com,
        virtualization@lists.linux-foundation.org, rob.miller@broadcom.com,
        lulu@redhat.com, eperezma@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, haotian.wang@sifive.com,
        zhi.a.wang@intel.com, farman@linux.ibm.com, idos@mellanox.com,
        gor@linux.ibm.com, cunming.liang@intel.com, rodrigo.vivi@intel.com,
        xiao.w.wang@intel.com, freude@linux.ibm.com, parav@mellanox.com,
        zhihong.wang@intel.com, akrowiak@linux.ibm.com,
        netdev@vger.kernel.org, cohuck@redhat.com, oberpar@linux.ibm.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com
References: <20190923130331.29324-3-jasowang@redhat.com>
 <201909232342.R079Gsby%lkp@intel.com>
 <20190923113538-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cd1a6d66-df51-5b9a-0ac7-8ee75502868e@redhat.com>
Date:   Tue, 24 Sep 2019 19:23:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190923113538-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 24 Sep 2019 11:24:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/23 下午11:36, Michael S. Tsirkin wrote:
> On Mon, Sep 23, 2019 at 11:20:12PM +0800, kbuild test robot wrote:
>> Hi Jason,
>>
>> I love your patch! Yet something to improve:
>>
>> [auto build test ERROR on linus/master]
>> [cannot apply to v5.3 next-20190920]
>> [if your patch is applied to the wrong git tree, please drop us a note to help
>> improve the system. BTW, we also suggest to use '--base' option to specify the
>> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
>>
>> url:    https://github.com/0day-ci/linux/commits/Jason-Wang/mdev-based-hardware-virtio-offloading-support/20190923-210738
>> config: ia64-allmodconfig (attached as .config)
>> compiler: ia64-linux-gcc (GCC) 7.4.0
>> reproduce:
>>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>         chmod +x ~/bin/make.cross
>>         # save the attached .config to linux build tree
>>         GCC_VERSION=7.4.0 make.cross ARCH=ia64 
>>
>> If you fix the issue, kindly add following tag
>> Reported-by: kbuild test robot <lkp@intel.com>
>>
>> All error/warnings (new ones prefixed by >>):
> Looks like a bunch of includes missing. I guess they happen to
> be pulled in on some platforms but not others - ideally
> headers should be self contained though, pulling in
> all their dependencies.


Right, will fix in V2.

Thanks


>
>
>>    In file included from include/linux/vfio_mdev.h:10:0,
>>                     from <command-line>:0:
>>>> include/linux/mdev.h:25:34: warning: 'struct device' declared inside parameter list will not be visible outside of this definition or declaration
>>     int mdev_set_iommu_device(struct device *dev, struct device *iommu_device);
>>                                      ^~~~~~
>>>> include/linux/mdev.h:62:27: warning: 'struct kobject' declared inside parameter list will not be visible outside of this definition or declaration
>>      int     (*create)(struct kobject *kobj, struct mdev_device *mdev);
>>                               ^~~~~~~
>>>> include/linux/mdev.h:69:19: error: field 'attr' has incomplete type
>>      struct attribute attr;
>>                       ^~~~
>>    include/linux/mdev.h:70:25: warning: 'struct kobject' declared inside parameter list will not be visible outside of this definition or declaration
>>      ssize_t (*show)(struct kobject *kobj, struct device *dev, char *buf);
>>                             ^~~~~~~
>>    include/linux/mdev.h:71:26: warning: 'struct kobject' declared inside parameter list will not be visible outside of this definition or declaration
>>      ssize_t (*store)(struct kobject *kobj, struct device *dev,
>>                              ^~~~~~~
>>>> include/linux/mdev.h:98:23: error: field 'driver' has incomplete type
>>      struct device_driver driver;
>>                           ^~~~~~
>>>> include/linux/mdev.h:106:7: error: unknown type name 'guid_t'
>>     const guid_t *mdev_uuid(struct mdev_device *mdev);
>>           ^~~~~~
>>    In file included from <command-line>:0:0:
>>>> include/linux/vfio_mdev.h:50:47: warning: 'struct vm_area_struct' declared inside parameter list will not be visible outside of this definition or declaration
>>      int (*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
>>                                                   ^~~~~~~~~~~~~~
>>
>> vim +/attr +69 include/linux/mdev.h
>>
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   14  
>> 8ac13175cbe985 Lu Baolu        2019-04-12   15  /*
>> 8ac13175cbe985 Lu Baolu        2019-04-12   16   * Called by the parent device driver to set the device which represents
>> 8ac13175cbe985 Lu Baolu        2019-04-12   17   * this mdev in iommu protection scope. By default, the iommu device is
>> 8ac13175cbe985 Lu Baolu        2019-04-12   18   * NULL, that indicates using vendor defined isolation.
>> 8ac13175cbe985 Lu Baolu        2019-04-12   19   *
>> 8ac13175cbe985 Lu Baolu        2019-04-12   20   * @dev: the mediated device that iommu will isolate.
>> 8ac13175cbe985 Lu Baolu        2019-04-12   21   * @iommu_device: a pci device which represents the iommu for @dev.
>> 8ac13175cbe985 Lu Baolu        2019-04-12   22   *
>> 8ac13175cbe985 Lu Baolu        2019-04-12   23   * Return 0 for success, otherwise negative error value.
>> 8ac13175cbe985 Lu Baolu        2019-04-12   24   */
>> 8ac13175cbe985 Lu Baolu        2019-04-12  @25  int mdev_set_iommu_device(struct device *dev, struct device *iommu_device);
>> 8ac13175cbe985 Lu Baolu        2019-04-12   26  
>> 8ac13175cbe985 Lu Baolu        2019-04-12   27  struct device *mdev_get_iommu_device(struct device *dev);
>> 8ac13175cbe985 Lu Baolu        2019-04-12   28  
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   29  /**
>> 42930553a7c11f Alex Williamson 2016-12-30   30   * struct mdev_parent_ops - Structure to be registered for each parent device to
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   31   * register the device to mdev module.
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   32   *
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   33   * @owner:		The module owner.
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   34   * @dev_attr_groups:	Attributes of the parent device.
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   35   * @mdev_attr_groups:	Attributes of the mediated device.
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   36   * @supported_type_groups: Attributes to define supported types. It is mandatory
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   37   *			to provide supported types.
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   38   * @create:		Called to allocate basic resources in parent device's
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   39   *			driver for a particular mediated device. It is
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   40   *			mandatory to provide create ops.
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   41   *			@kobj: kobject of type for which 'create' is called.
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   42   *			@mdev: mdev_device structure on of mediated device
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   43   *			      that is being created
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   44   *			Returns integer: success (0) or error (< 0)
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   45   * @remove:		Called to free resources in parent device's driver for a
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   46   *			a mediated device. It is mandatory to provide 'remove'
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   47   *			ops.
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   48   *			@mdev: mdev_device device structure which is being
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   49   *			       destroyed
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   50   *			Returns integer: success (0) or error (< 0)
>> 0baad8a6f6fefa Jason Wang      2019-09-23   51   * @device_ops:         Device specific emulation callback.
>> 0baad8a6f6fefa Jason Wang      2019-09-23   52   *
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   53   * Parent device that support mediated device should be registered with mdev
>> 42930553a7c11f Alex Williamson 2016-12-30   54   * module with mdev_parent_ops structure.
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   55   **/
>> 42930553a7c11f Alex Williamson 2016-12-30   56  struct mdev_parent_ops {
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   57  	struct module   *owner;
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   58  	const struct attribute_group **dev_attr_groups;
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   59  	const struct attribute_group **mdev_attr_groups;
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   60  	struct attribute_group **supported_type_groups;
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   61  
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17  @62  	int     (*create)(struct kobject *kobj, struct mdev_device *mdev);
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   63  	int     (*remove)(struct mdev_device *mdev);
>> 0baad8a6f6fefa Jason Wang      2019-09-23   64  	const void *device_ops;
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   65  };
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   66  
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   67  /* interface for exporting mdev supported type attributes */
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   68  struct mdev_type_attribute {
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17  @69  	struct attribute attr;
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17  @70  	ssize_t (*show)(struct kobject *kobj, struct device *dev, char *buf);
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   71  	ssize_t (*store)(struct kobject *kobj, struct device *dev,
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   72  			 const char *buf, size_t count);
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   73  };
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   74  
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   75  #define MDEV_TYPE_ATTR(_name, _mode, _show, _store)		\
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   76  struct mdev_type_attribute mdev_type_attr_##_name =		\
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   77  	__ATTR(_name, _mode, _show, _store)
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   78  #define MDEV_TYPE_ATTR_RW(_name) \
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   79  	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_RW(_name)
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   80  #define MDEV_TYPE_ATTR_RO(_name) \
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   81  	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_RO(_name)
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   82  #define MDEV_TYPE_ATTR_WO(_name) \
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   83  	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_WO(_name)
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   84  
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   85  /**
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   86   * struct mdev_driver - Mediated device driver
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   87   * @name: driver name
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   88   * @probe: called when new device created
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   89   * @remove: called when device removed
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   90   * @driver: device driver structure
>> 6294ee8e0b5153 Jason Wang      2019-09-23   91   * @id_table: the ids serviced by this driver.
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   92   *
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   93   **/
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   94  struct mdev_driver {
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   95  	const char *name;
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   96  	int  (*probe)(struct device *dev);
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17   97  	void (*remove)(struct device *dev);
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17  @98  	struct device_driver driver;
>> 6294ee8e0b5153 Jason Wang      2019-09-23   99  	const struct mdev_class_id *id_table;
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17  100  };
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17  101  
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17  102  #define to_mdev_driver(drv)	container_of(drv, struct mdev_driver, driver)
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17  103  
>> 50732af3b65691 Parav Pandit    2019-04-30  104  void *mdev_get_drvdata(struct mdev_device *mdev);
>> 50732af3b65691 Parav Pandit    2019-04-30  105  void mdev_set_drvdata(struct mdev_device *mdev, void *data);
>> 50732af3b65691 Parav Pandit    2019-04-30 @106  const guid_t *mdev_uuid(struct mdev_device *mdev);
>> 7b96953bc640b6 Kirti Wankhede  2016-11-17  107  
>>
>> :::::: The code at line 69 was first introduced by commit
>> :::::: 7b96953bc640b6b25665fe17ffca4b668b371f14 vfio: Mediated device Core driver
>>
>> :::::: TO: Kirti Wankhede <kwankhede@nvidia.com>
>> :::::: CC: Alex Williamson <alex.williamson@redhat.com>
>>
>> ---
>> 0-DAY kernel test infrastructure                Open Source Technology Center
>> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
